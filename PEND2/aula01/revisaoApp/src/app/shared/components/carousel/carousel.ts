import { Component } from '@angular/core';
import { ICarouselModel } from './interfaces/carousel-model';

@Component({
  selector: 'app-carousel',
  standalone: true,
  templateUrl: './carousel.html',
  styleUrl: './carousel.css',
})
export class Carousel {
  readonly slides : ICarouselModel[] = [
    { title: 'First slide', color: 'bg-slate-200', text: 'text-slate-700' },
    { title: 'Second slide', color: 'bg-slate-300', text: 'text-slate-800' },
    { title: 'Third slide', color: 'bg-slate-400', text: 'text-white' },
  ];

  currentIndex = 0;

  get currentSlide() {
    return this.slides[this.currentIndex];
  }

  next(): void {
    this.currentIndex = (this.currentIndex + 1) % this.slides.length;
  }

  prev(): void {
    this.currentIndex = (this.currentIndex - 1 + this.slides.length) % this.slides.length;
  }

  goTo(index: number): void {
    this.currentIndex = index;
  }
}
