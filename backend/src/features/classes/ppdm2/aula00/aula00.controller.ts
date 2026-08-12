import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
} from '@nestjs/common';
import { Aula00Service } from './aula00.service';
import type { IApiResponse } from 'src/shared/interfaces/api-response';
import type { ICreateAlunoDto } from './dto/create-aluno.dto';

@Controller('aula00')
export class Aula00Controller {
  constructor(private readonly aulaService: Aula00Service) {}

  @Get('alunos')
  getAlunos(): Promise<IApiResponse> {
    return this.aulaService.getAlunos();
  }

  @Post('alunos')
  createAluno(@Body() dto: ICreateAlunoDto): Promise<IApiResponse> {
    return this.aulaService.createAluno(dto);
  }

  @Delete('alunos/:id')
  deleteAluno(@Param('id', ParseIntPipe) id: number): Promise<IApiResponse> {
    return this.aulaService.deleteAluno(id);
  }
}
