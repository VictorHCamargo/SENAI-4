import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
} from '@nestjs/common';
import { Aula00Service } from './aula00.service';
import type { IApiResponse } from 'src/shared/interfaces/api-response';
import type { ICreateAlunoDto, IUpdateAlunoDto } from './dto/create-aluno.dto';

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

  @Put('alunos/:id')
  updateAluno(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: IUpdateAlunoDto,
  ): Promise<IApiResponse> {
    return this.aulaService.updateAluno(id, dto);
  }

  @Delete('alunos/:id')
  deleteAluno(@Param('id', ParseIntPipe) id: number): Promise<IApiResponse> {
    return this.aulaService.deleteAluno(id);
  }
}
