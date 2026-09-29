"use client";

import React, { useState, useEffect, useCallback } from "react";
import Link from "next/link";
import { ShieldCheck, ArrowRight, ChevronLeft, ChevronRight, Pause, Play } from "lucide-react";

interface SlideData {
  image: string;
  badge: string;
  titleBefore: string;
  highlight: string;
  titleAfter: string;
  description: string;
  primaryCtaText: string;
  primaryCtaLink: string;
  secondaryCtaText: string;
  secondaryCtaLink: string;
}

const slides: SlideData[] = [
  {
    image: "/uploads/2021/12/green-rig-header-web.jpg",
    badge: "API & ISO Certified Manufacturer Since 1980",
    titleBefore: "Engineering ",
    highlight: "Total Solutions",
    titleAfter: " for Global Energy",
    description:
      "Worldwide Oilfield Machine (WOM) is a multinational manufacturer specializing in high-performance pressure control, surface wellheads, and subsea intervention systems.",
    primaryCtaText: "Explore 96+ Products",
    primaryCtaLink: "/products",
    secondaryCtaText: "Request a Quote",
    secondaryCtaLink: "/contact-us",
  },
  {
    image: "/uploads/2021/12/bop-homepage-banner-web.jpg",
    badge: "Severe Service Well Control",
    titleBefore: "Next-Generation ",
    highlight: "BOP & Wellhead",
    titleAfter: " Systems",
    description:
      "Engineered with WOM's patented bi-directional Dual Seal technology for extreme HPHT environments, subsea drilling, and intervention operations.",
    primaryCtaText: "View BOP Systems",
    primaryCtaLink: "/products/category/bops",
    secondaryCtaText: "Our Technologies",
    secondaryCtaLink: "/patents",
  },
  {
    image: "/uploads/2025/08/DJI_20230711_111922_102.jpg",
    badge: "17 Global Facilities & Tech Centers",
    titleBefore: "Worldwide Scale, ",
    highlight: "Local Engineering",
    titleAfter: " Support",
    description:
      "Strategically located manufacturing facilities, cleanrooms, and testing bays in Houston, Aberdeen, Dubai, Pune, and Singapore.",
    primaryCtaText: "Explore Global Hubs",
    primaryCtaLink: "/locations",
    secondaryCtaText: "Corporate Story",
    secondaryCtaLink: "/our-story",
  },
  {
    image: "/uploads/2025/08/Steel.jpg",
    badge: "100% Complete Vertical Integration",
    titleBefore: "From Raw Ingot to ",
    highlight: "Precision Finished",
    titleAfter: " Equipment",
    description:
      "Our in-house foundry, forging, and advanced metallurgy centers (Magna Casting & Magnum Forge) provide total quality control from start to finish.",
    primaryCtaText: "Quality & Policies",
    primaryCtaLink: "/our-core-policies",
    secondaryCtaText: "Contact Us",
    secondaryCtaLink: "/contact-us",
  },
];

export function HeroSlider() {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isPaused, setIsPaused] = useState(false);

  const nextSlide = useCallback(() => {
    setCurrentIndex((prev) => (prev + 1) % slides.length);
  }, []);

  const prevSlide = useCallback(() => {
    setCurrentIndex((prev) => (prev - 1 + slides.length) % slides.length);
  }, []);

  useEffect(() => {
    if (isPaused) return;
    const interval = setInterval(nextSlide, 6500);
    return () => clearInterval(interval);
  }, [nextSlide, isPaused]);

  return (
    <div
      className="relative bg-black text-white overflow-hidden select-none min-h-[640px] lg:min-h-[720px] flex items-center"
      onMouseEnter={() => setIsPaused(true)}
      onMouseLeave={() => setIsPaused(false)}
    >
      {/* Background Slides with Crossfade */}
      {slides.map((slide, index) => {
        const isActive = index === currentIndex;
        return (
          <div
            key={slide.image}
            className={`absolute inset-0 transition-opacity duration-1000 ease-in-out ${
              isActive ? "opacity-100 z-0 scale-100" : "opacity-0 -z-10 scale-105 pointer-events-none"
            } transform transition-transform duration-[7000ms]`}
          >
            <img
              src={slide.image}
              alt={slide.highlight}
              className="w-full h-full object-cover object-center"
              loading={index === 0 ? "eager" : "lazy"}
            />
            {/* Multi-layered gradient overlays for perfect readability */}
            <div className="absolute inset-0 bg-gradient-to-r from-black/90 via-black/70 to-black/40" />
            <div className="absolute inset-0 bg-gradient-to-t from-black via-transparent to-black/50" />
          </div>
        );
      })}

      {/* Subtle grid pattern background texture */}
      <div className="absolute inset-0 opacity-15 bg-[radial-gradient(#ea7600_1px,transparent_1px)] [background-size:24px_24px] pointer-events-none z-10" />

      {/* Content Container */}
      <div className="relative z-20 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 lg:py-28 w-full">
        <div className="max-w-3xl space-y-6">
          {/* Badge */}
          <div className="inline-flex items-center gap-2 bg-black/60 backdrop-blur-md border border-wom-orange/50 text-wom-orange text-xs font-bold uppercase tracking-wider px-4 py-1.5 rounded-full shadow-lg transition-all">
            <ShieldCheck className="w-4 h-4 text-wom-orange shrink-0" />
            <span>{slides[currentIndex].badge}</span>
          </div>

          {/* Heading */}
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-black tracking-tight leading-tight drop-shadow-md">
            {slides[currentIndex].titleBefore}
            <span className="text-wom-orange underline decoration-wom-orange/40 decoration-4 underline-offset-8">
              {slides[currentIndex].highlight}
            </span>
            {slides[currentIndex].titleAfter}
          </h1>

          {/* Description */}
          <p className="text-base sm:text-lg lg:text-xl text-gray-200 font-light leading-relaxed max-w-2xl drop-shadow">
            {slides[currentIndex].description}
          </p>

          {/* CTAs */}
          <div className="flex flex-wrap items-center gap-4 pt-4">
            <Link
              href={slides[currentIndex].primaryCtaLink}
              className="bg-wom-orange hover:bg-wom-orangeHover text-white px-8 py-3.5 rounded-full font-bold transition shadow-lg hover:shadow-orange-500/25 flex items-center gap-2"
            >
              <span>{slides[currentIndex].primaryCtaText}</span>
              <ArrowRight className="w-4 h-4" />
            </Link>
            <Link
              href={slides[currentIndex].secondaryCtaLink}
              className="bg-white/10 hover:bg-white/20 text-white border border-white/30 hover:border-white/50 px-8 py-3.5 rounded-full font-semibold transition backdrop-blur-md"
            >
              {slides[currentIndex].secondaryCtaText}
            </Link>
          </div>
        </div>
      </div>

      {/* Floating Metrics bar pinned at bottom of hero */}
      <div className="absolute bottom-6 left-0 right-0 z-20 hidden md:block max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-4 gap-6 bg-black/60 backdrop-blur-md border border-white/15 rounded-2xl p-4 text-center">
          <div>
            <div className="text-2xl lg:text-3xl font-black text-wom-orange">40+</div>
            <div className="text-xs text-gray-300 font-medium">Years of Innovation</div>
          </div>
          <div>
            <div className="text-2xl lg:text-3xl font-black text-white">96+</div>
            <div className="text-xs text-gray-300 font-medium">Engineered Products</div>
          </div>
          <div>
            <div className="text-2xl lg:text-3xl font-black text-wom-orange">17</div>
            <div className="text-xs text-gray-300 font-medium">Global Facilities</div>
          </div>
          <div>
            <div className="text-2xl lg:text-3xl font-black text-white">100%</div>
            <div className="text-xs text-gray-300 font-medium">Vertical Integration</div>
          </div>
        </div>
      </div>

      {/* Slider Navigation Arrows */}
      <button
        onClick={prevSlide}
        aria-label="Previous Slide"
        className="absolute left-4 top-1/2 -translate-y-1/2 z-30 p-2.5 rounded-full bg-black/40 hover:bg-wom-orange text-white border border-white/20 transition backdrop-blur-sm hidden sm:flex items-center justify-center group"
      >
        <ChevronLeft className="w-5 h-5 group-hover:-translate-x-0.5 transition-transform" />
      </button>

      <button
        onClick={nextSlide}
        aria-label="Next Slide"
        className="absolute right-4 top-1/2 -translate-y-1/2 z-30 p-2.5 rounded-full bg-black/40 hover:bg-wom-orange text-white border border-white/20 transition backdrop-blur-sm hidden sm:flex items-center justify-center group"
      >
        <ChevronRight className="w-5 h-5 group-hover:translate-x-0.5 transition-transform" />
      </button>

      {/* Slider Dots / Indicators */}
      <div className="absolute right-6 top-1/2 -translate-y-1/2 z-30 hidden lg:flex flex-col gap-3">
        {slides.map((_, index) => (
          <button
            key={index}
            onClick={() => setCurrentIndex(index)}
            aria-label={`Go to slide ${index + 1}`}
            className={`transition-all duration-300 rounded-full ${
              index === currentIndex
                ? "w-3 h-8 bg-wom-orange ring-2 ring-white/50"
                : "w-3 h-3 bg-white/40 hover:bg-white"
            }`}
          />
        ))}
      </div>
    </div>
  );
}
