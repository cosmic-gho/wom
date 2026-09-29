"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Menu, X, ChevronDown, Phone, Mail, Globe, Search } from "lucide-react";

export function Header() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [productsOpen, setProductsOpen] = useState(false);
  const [aboutOpen, setAboutOpen] = useState(false);

  return (
    <header className="sticky top-0 z-50 bg-white border-b border-gray-200 shadow-sm">
      {/* Top utility bar */}
      <div className="bg-wom-dark text-gray-300 text-xs py-2 px-4 sm:px-8 flex justify-between items-center">
        <div className="flex items-center gap-6">
          <span className="flex items-center gap-1.5">
            <Globe className="w-3.5 h-3.5 text-wom-orange" />
            Global Presence: Houston • Dubai • Aberdeen • Pune • Singapore
          </span>
        </div>
        <div className="hidden md:flex items-center gap-6">
          <a
            href="mailto:info@womgroup.com"
            className="flex items-center gap-1.5 hover:text-white transition"
          >
            <Mail className="w-3.5 h-3.5 text-wom-orange" />
            info@womgroup.com
          </a>
          <a
            href="tel:+18328028000"
            className="flex items-center gap-1.5 hover:text-white transition"
          >
            <Phone className="w-3.5 h-3.5 text-wom-orange" />
            +1 (832) 802-8000
          </a>
        </div>
      </div>

      {/* Main navigation */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-20">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-3">
            <div className="flex flex-col">
              <span className="text-2xl font-black tracking-wider text-wom-dark flex items-center">
                <span className="text-wom-orange">W</span>OM
                <span className="ml-1 text-xs uppercase px-1.5 py-0.5 rounded bg-wom-orange text-white font-bold tracking-normal">
                  GROUP
                </span>
              </span>
              <span className="text-[10px] text-gray-500 font-medium tracking-tight">
                Worldwide Oilfield Machine
              </span>
            </div>
          </Link>

          {/* Desktop Nav */}
          <nav className="hidden lg:flex items-center gap-7 text-sm font-semibold text-gray-700">
            <Link href="/" className="hover:text-wom-orange transition">
              Home
            </Link>

            {/* About Dropdown */}
            <div
              className="relative"
              onMouseEnter={() => setAboutOpen(true)}
              onMouseLeave={() => setAboutOpen(false)}
            >
              <button className="flex items-center gap-1 hover:text-wom-orange py-2 transition">
                <span>About Us</span>
                <ChevronDown className="w-4 h-4" />
              </button>
              {aboutOpen && (
                <div className="absolute top-full left-0 w-56 bg-white border border-gray-100 rounded-lg shadow-xl py-2 z-50">
                  <Link
                    href="/our-story"
                    className="block px-4 py-2 hover:bg-orange-50 hover:text-wom-orange text-gray-700 transition"
                  >
                    Our Story
                  </Link>
                  <Link
                    href="/our-core-policies"
                    className="block px-4 py-2 hover:bg-orange-50 hover:text-wom-orange text-gray-700 transition"
                  >
                    Our Core Policies
                  </Link>
                  <Link
                    href="/certifications"
                    className="block px-4 py-2 hover:bg-orange-50 hover:text-wom-orange text-gray-700 transition"
                  >
                    Certifications
                  </Link>
                  <Link
                    href="/patents"
                    className="block px-4 py-2 hover:bg-orange-50 hover:text-wom-orange text-gray-700 transition"
                  >
                    Patents & IP
                  </Link>
                  <Link
                    href="/americandream"
                    className="block px-4 py-2 hover:bg-orange-50 hover:text-wom-orange text-gray-700 transition"
                  >
                    The American Dream
                  </Link>
                </div>
              )}
            </div>

            {/* Products Dropdown */}
            <div
              className="relative"
              onMouseEnter={() => setProductsOpen(true)}
              onMouseLeave={() => setProductsOpen(false)}
            >
              <Link
                href="/products"
                className="flex items-center gap-1 hover:text-wom-orange py-2 transition"
              >
                <span>Products</span>
                <ChevronDown className="w-4 h-4" />
              </Link>
              {productsOpen && (
                <div className="absolute top-full left-0 w-64 bg-white border border-gray-100 rounded-lg shadow-xl py-2 z-50">
                  <Link
                    href="/products"
                    className="block px-4 py-2 font-bold text-wom-orange hover:bg-orange-50 transition border-b border-gray-100"
                  >
                    View All Products (96+)
                  </Link>
                  <Link
                    href="/products/category/gate-valves"
                    className="block px-4 py-2 hover:bg-orange-50 hover:text-wom-orange text-gray-700 transition"
                  >
                    Gate Valves
                  </Link>
                  <Link
                    href="/products/category/ball-valves"
                    className="block px-4 py-2 hover:bg-orange-50 hover:text-wom-orange text-gray-700 transition"
                  >
                    Ball Valves
                  </Link>
                  <Link
                    href="/products/category/bops"
                    className="block px-4 py-2 hover:bg-orange-50 hover:text-wom-orange text-gray-700 transition"
                  >
                    Blowout Preventers (BOPs)
                  </Link>
                  <Link
                    href="/products/category/chokes"
                    className="block px-4 py-2 hover:bg-orange-50 hover:text-wom-orange text-gray-700 transition"
                  >
                    Chokes & Flow Control
                  </Link>
                  <Link
                    href="/products/category/wellheads-christmas-trees"
                    className="block px-4 py-2 hover:bg-orange-50 hover:text-wom-orange text-gray-700 transition"
                  >
                    Wellheads & Trees
                  </Link>
                  <Link
                    href="/products/category/si-systems"
                    className="block px-4 py-2 hover:bg-orange-50 hover:text-wom-orange text-gray-700 transition"
                  >
                    Subsea Intervention Systems
                  </Link>
                </div>
              )}
            </div>

            <Link href="/locations" className="hover:text-wom-orange transition">
              Locations
            </Link>
            <Link href="/news" className="hover:text-wom-orange transition">
              News
            </Link>
            <Link href="/resources" className="hover:text-wom-orange transition">
              Resources
            </Link>
            <Link href="/wom-careers" className="hover:text-wom-orange transition">
              Careers
            </Link>
          </nav>

          {/* Action Button */}
          <div className="hidden lg:flex items-center gap-4">
            <Link
              href="/contact-us"
              className="bg-wom-orange hover:bg-wom-orangeHover text-white px-5 py-2.5 rounded-full text-sm font-semibold transition shadow hover:shadow-md"
            >
              Contact Us
            </Link>
          </div>

          {/* Mobile hamburger button */}
          <div className="lg:hidden flex items-center">
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="p-2 rounded-md text-gray-700 hover:text-wom-orange hover:bg-gray-100 transition"
              aria-label="Toggle Menu"
            >
              {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Menu */}
      {mobileMenuOpen && (
        <div className="lg:hidden bg-white border-t border-gray-100 px-4 pt-3 pb-6 space-y-2 shadow-lg">
          <Link
            href="/"
            onClick={() => setMobileMenuOpen(false)}
            className="block px-3 py-2 rounded text-base font-semibold text-gray-800 hover:bg-orange-50 hover:text-wom-orange"
          >
            Home
          </Link>
          <div className="border-t border-gray-100 pt-2">
            <span className="block px-3 py-1 text-xs uppercase font-bold text-gray-400">
              About Us
            </span>
            <Link
              href="/our-story"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-3 py-1.5 text-sm text-gray-700 hover:text-wom-orange"
            >
              Our Story
            </Link>
            <Link
              href="/our-core-policies"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-3 py-1.5 text-sm text-gray-700 hover:text-wom-orange"
            >
              Our Core Policies
            </Link>
            <Link
              href="/certifications"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-3 py-1.5 text-sm text-gray-700 hover:text-wom-orange"
            >
              Certifications
            </Link>
            <Link
              href="/patents"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-3 py-1.5 text-sm text-gray-700 hover:text-wom-orange"
            >
              Patents
            </Link>
          </div>

          <div className="border-t border-gray-100 pt-2">
            <span className="block px-3 py-1 text-xs uppercase font-bold text-gray-400">
              Products
            </span>
            <Link
              href="/products"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-3 py-1.5 text-sm font-semibold text-wom-orange"
            >
              All Products
            </Link>
            <Link
              href="/products/category/gate-valves"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-3 py-1.5 text-sm text-gray-700 hover:text-wom-orange"
            >
              Gate Valves
            </Link>
            <Link
              href="/products/category/bops"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-3 py-1.5 text-sm text-gray-700 hover:text-wom-orange"
            >
              BOPs
            </Link>
          </div>

          <Link
            href="/locations"
            onClick={() => setMobileMenuOpen(false)}
            className="block px-3 py-2 rounded text-base font-semibold text-gray-800 hover:bg-orange-50 hover:text-wom-orange"
          >
            Locations
          </Link>
          <Link
            href="/news"
            onClick={() => setMobileMenuOpen(false)}
            className="block px-3 py-2 rounded text-base font-semibold text-gray-800 hover:bg-orange-50 hover:text-wom-orange"
          >
            News
          </Link>
          <Link
            href="/resources"
            onClick={() => setMobileMenuOpen(false)}
            className="block px-3 py-2 rounded text-base font-semibold text-gray-800 hover:bg-orange-50 hover:text-wom-orange"
          >
            Resources
          </Link>
          <Link
            href="/wom-careers"
            onClick={() => setMobileMenuOpen(false)}
            className="block px-3 py-2 rounded text-base font-semibold text-gray-800 hover:bg-orange-50 hover:text-wom-orange"
          >
            Careers
          </Link>
          <div className="pt-2">
            <Link
              href="/contact-us"
              onClick={() => setMobileMenuOpen(false)}
              className="block text-center bg-wom-orange hover:bg-wom-orangeHover text-white px-4 py-2.5 rounded-full font-semibold"
            >
              Contact Us
            </Link>
          </div>
        </div>
      )}
    </header>
  );
}
