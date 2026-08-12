import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('alunos')
export class AlunoEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar' })
  nome: string;

  @Column({ type: 'int' })
  idade: number;

  @Column({ type: 'varchar' })
  curso: string;
}
