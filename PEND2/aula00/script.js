const icones = {
  Temperatura: "🌡️",
  Umidade: "💧",
  Pressão: "⏲️"
};

const URL_BASE = "http://localhost:3000/aulas/pend2/aula00/sensors";
const CHAVE_HISTORICO = "historicoSensores";
const LIMITE_HISTORICO = 30;

let sensoresIniciais = [];

const container = document.getElementById("gridSensores");
const selectFiltro = document.getElementById("filtroTipo");
const btnAtualizar = document.getElementById("btnAtualizar");
const ultimoTimestamp = document.getElementById("ultimoTimestamp");
const statusIndicator = document.getElementById("statusIndicator");
const statusTexto = document.getElementById("statusTexto");
const modalHistorico = document.getElementById("modalHistorico");
const modalHistoricoTitulo = document.getElementById("modalHistoricoTitulo");
const listaHistorico = document.getElementById("listaHistorico");
const btnFecharHistorico = document.getElementById("btnFecharHistorico");

function carregarHistorico() {
  const bruto = localStorage.getItem(CHAVE_HISTORICO);
  return bruto ? JSON.parse(bruto) : {};
}

function salvarHistoricoCompleto(historico) {
  localStorage.setItem(CHAVE_HISTORICO, JSON.stringify(historico));
}

function registrarHistorico(listaSensores) {
  const historico = carregarHistorico();
  const agora = new Date().toISOString();

  listaSensores.forEach((sensor) => {
    if (!historico[sensor.id]) {
      historico[sensor.id] = [];
    }
    historico[sensor.id].unshift({
      valor: sensor.valor,
      unidade: sensor.unidade,
      status: sensor.status,
      timestamp: agora
    });
    historico[sensor.id] = historico[sensor.id].slice(0, LIMITE_HISTORICO);
  });

  salvarHistoricoCompleto(historico);
}

function formatarTimestamp(iso) {
  const data = new Date(iso);
  return data.toLocaleString("pt-BR");
}

function abrirHistorico(sensorId) {
  const sensor = sensoresIniciais.find((item) => item.id === Number(sensorId));
  const historico = carregarHistorico()[sensorId] || [];

  modalHistoricoTitulo.textContent = sensor ? `Histórico - ${sensor.nome}` : "Histórico";
  listaHistorico.innerHTML = "";

  if (historico.length === 0) {
    const vazio = document.createElement("li");
    vazio.className = "modal__vazio";
    vazio.textContent = "Nenhum registro ainda.";
    listaHistorico.appendChild(vazio);
  } else {
    historico.forEach((registro) => {
      const item = document.createElement("li");
      item.className = "modal__item";
      if (registro.status === "critico") {
        item.classList.add("modal__item--critico");
      }
      item.innerHTML = `
        <span>${formatarTimestamp(registro.timestamp)}</span>
        <span>${registro.valor.toFixed(1)}${registro.unidade}</span>
      `;
      listaHistorico.appendChild(item);
    });
  }

  modalHistorico.classList.remove("modal--oculto");
}

function fecharHistorico() {
  modalHistorico.classList.add("modal--oculto");
}

function criarCard(sensor) {
  const card = document.createElement("article");
  card.className = "card";
  if (sensor.status === "critico") {
    card.classList.add("card-alerta");
  }

  card.innerHTML = `
    <div class="card__topo">
      <span class="card__icone">${icones[sensor.tipo] || "📟"}</span>
      <span class="card__tipo">${sensor.tipo}</span>
    </div>
    <div class="card__nome">${sensor.nome}</div>
    <div class="card__valor">${sensor.valor.toFixed(1)}${sensor.unidade}</div>
    <div class="card__rodape">
      <span>${sensor.status === "critico" ? "⚠️ Crítico" : "✅ Normal"}</span>
      <button class="card__btn-historico" data-id="${sensor.id}">Histórico</button>
    </div>
  `;

  return card;
}

function renderizarDashboard(listaSensores) {
  container.innerHTML = "";
  listaSensores.forEach((sensor) => {
    container.appendChild(criarCard(sensor));
  });
}

function atualizarTimestamp() {
  const agora = new Date();
  const horas = String(agora.getHours()).padStart(2, "0");
  const minutos = String(agora.getMinutes()).padStart(2, "0");
  const segundos = String(agora.getSeconds()).padStart(2, "0");
  ultimoTimestamp.textContent = `${horas}:${minutos}:${segundos}`;
}

function obterListaFiltrada() {
  const tipoSelecionado = selectFiltro.value;
  if (tipoSelecionado === "Todos") {
    return sensoresIniciais;
  }
  return sensoresIniciais.filter((sensor) => sensor.tipo === tipoSelecionado);
}

async function atualizarStatusConexao() {
  const resposta = await fetch(URL_BASE.replace('sensors','health'));
  const dados = await resposta.json();
  const online = dados.
  if(online)
  statusIndicator.classList.toggle("status-dot--online", online);
  statusIndicator.classList.toggle("status-dot--offline", !online);
  statusTexto.textContent = online ? "Online" : "Offline";
}

async function buscarSensores() {
  const resposta = await fetch(URL_BASE);
  const dados = await resposta.json();
  return dados.data;
}

async function atualizarSensoresNoBackend() {
  const resposta = await fetch(URL_BASE, { method: "PATCH" });
  const dados = await resposta.json();
  return dados.data;
}

async function carregarDashboard() {
  try {
    sensoresIniciais = await buscarSensores();
    registrarHistorico(sensoresIniciais);
    renderizarDashboard(obterListaFiltrada());
    atualizarTimestamp();
  } catch (erro) {
    console.error("Falha na requisição:", erro);
  }
}

async function atualizarDashboard() {
  try {
    sensoresIniciais = await atualizarSensoresNoBackend();
    registrarHistorico(sensoresIniciais);
    renderizarDashboard(obterListaFiltrada());
    atualizarTimestamp();
  } catch (erro) {
    console.error("Falha na requisição:", erro);
  }
}

selectFiltro.addEventListener("change", () => {
  renderizarDashboard(obterListaFiltrada());
});

btnAtualizar.addEventListener("click", atualizarDashboard);

container.addEventListener("click", (evento) => {
  const botao = evento.target.closest(".card__btn-historico");
  if (botao) {
    abrirHistorico(botao.dataset.id);
  }
});

btnFecharHistorico.addEventListener("click", fecharHistorico);

modalHistorico.addEventListener("click", (evento) => {
  if (evento.target === modalHistorico) {
    fecharHistorico();
  }
});

window.addEventListener("online", atualizarStatusConexao);
window.addEventListener("offline", atualizarStatusConexao);

setInterval(atualizarDashboard, 30000);

async function controleSistema() {
  await carregarDashboard();
  atualizarStatusConexao();
}

controleSistema();
