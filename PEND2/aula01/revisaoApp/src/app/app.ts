import { Component, signal } from '@angular/core';
import { Card } from './shared/components/card/card';
import { Carousel } from './shared/components/carousel/carousel';
import { Footer } from './shared/components/footer/footer';

@Component({
  selector: 'app-root',
  imports: [Card, Carousel, Footer],
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App {
  protected readonly title = signal('revisaoApp');
}
