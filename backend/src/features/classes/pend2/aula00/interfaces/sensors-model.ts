export interface ISensorsModel {
  id: number;
  nome: string;
  tipo: TSensorsType;
  valor: number;
  unidade: string;
  status: string;
}

export type TSensorsType = 'Temperatura' | 'Umidade' | 'Pressão';
