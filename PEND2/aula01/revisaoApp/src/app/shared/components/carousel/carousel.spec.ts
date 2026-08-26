import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Carousel } from './carousel';

describe('Carousel', () => {
  let component: Carousel;
  let fixture: ComponentFixture<Carousel>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [Carousel],
    }).compileComponents();

    fixture = TestBed.createComponent(Carousel);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should go to the next slide', () => {
    component.next();
    expect(component.currentIndex).toBe(1);
  });

  it('should go to the previous slide and wrap around', () => {
    component.currentIndex = 0;
    component.prev();
    expect(component.currentIndex).toBe(component.slides.length - 1);
  });
});
