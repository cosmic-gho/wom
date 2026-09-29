import React from "react";
import Link from "next/link";
import { Phone, Mail, MapPin, Globe, ExternalLink } from "lucide-react";

export function Footer() {
  return (
    <footer className="bg-wom-dark text-gray-300 pt-16 pb-12 border-t border-gray-800">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-10 pb-12 border-b border-gray-800">
          {/* Brand & Corporate Statement */}
          <div className="lg:col-span-2 space-y-4">
            <Link href="/" className="inline-block">
              <span className="text-2xl font-black tracking-wider text-white flex items-center">
                <span className="text-wom-orange">W</span>OM
                <span className="ml-1 text-xs uppercase px-1.5 py-0.5 rounded bg-wom-orange text-white font-bold tracking-normal">
                  GROUP
                </span>
              </span>
            </Link>
            <p className="text-sm text-gray-400 leading-relaxed max-w-sm">
              Worldwide Oilfield Machine (WOM) is a globally recognized manufacturer and supplier of pressure control equipment for both surface and subsea applications in the oil and gas industry.
            </p>
            <div className="pt-2 text-sm text-gray-400 space-y-2">
              <div className="flex items-start gap-2.5">
                <MapPin className="w-4 h-4 text-wom-orange shrink-0 mt-0.5" />
                <span>11809 Canemont St, Houston, TX 77035, USA</span>
              </div>
              <div className="flex items-center gap-2.5">
                <Phone className="w-4 h-4 text-wom-orange shrink-0" />
                <a href="tel:+18328028000" className="hover:text-white transition">
                  +1 (832) 802-8000
                </a>
              </div>
              <div className="flex items-center gap-2.5">
                <Mail className="w-4 h-4 text-wom-orange shrink-0" />
                <a href="mailto:info@womgroup.com" className="hover:text-white transition">
                  info@womgroup.com
                </a>
              </div>
            </div>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="text-white text-sm font-bold uppercase tracking-wider mb-4">
              Company
            </h4>
            <ul className="space-y-2.5 text-sm text-gray-400">
              <li>
                <Link href="/our-story" className="hover:text-wom-orange transition">
                  Our Story
                </Link>
              </li>
              <li>
                <Link href="/our-core-policies" className="hover:text-wom-orange transition">
                  Core Policies
                </Link>
              </li>
              <li>
                <Link href="/certifications" className="hover:text-wom-orange transition">
                  Certifications
                </Link>
              </li>
              <li>
                <Link href="/patents" className="hover:text-wom-orange transition">
                  Patents & IP
                </Link>
              </li>
              <li>
                <Link href="/americandream" className="hover:text-wom-orange transition">
                  The American Dream
                </Link>
              </li>
              <li>
                <Link href="/wom-careers" className="hover:text-wom-orange transition">
                  Careers
                </Link>
              </li>
            </ul>
          </div>

          {/* Products */}
          <div>
            <h4 className="text-white text-sm font-bold uppercase tracking-wider mb-4">
              Key Products
            </h4>
            <ul className="space-y-2.5 text-sm text-gray-400">
              <li>
                <Link href="/products/category/gate-valves" className="hover:text-wom-orange transition">
                  Gate Valves
                </Link>
              </li>
              <li>
                <Link href="/products/category/ball-valves" className="hover:text-wom-orange transition">
                  Ball Valves
                </Link>
              </li>
              <li>
                <Link href="/products/category/bops" className="hover:text-wom-orange transition">
                  BOP Systems
                </Link>
              </li>
              <li>
                <Link href="/products/category/chokes" className="hover:text-wom-orange transition">
                  Chokes & Controls
                </Link>
              </li>
              <li>
                <Link href="/products/category/wellheads-christmas-trees" className="hover:text-wom-orange transition">
                  Wellheads & Trees
                </Link>
              </li>
              <li>
                <Link href="/products" className="text-wom-orange hover:underline inline-flex items-center gap-1 font-medium">
                  All 96+ Products &rarr;
                </Link>
              </li>
            </ul>
          </div>

          {/* Global Operations */}
          <div>
            <h4 className="text-white text-sm font-bold uppercase tracking-wider mb-4">
              Worldwide
            </h4>
            <ul className="space-y-2.5 text-sm text-gray-400">
              <li>
                <Link href="/locations" className="hover:text-wom-orange transition">
                  Houston Facilities (HQ)
                </Link>
              </li>
              <li>
                <Link href="/locations" className="hover:text-wom-orange transition">
                  United Kingdom (Aberdeen)
                </Link>
              </li>
              <li>
                <Link href="/locations" className="hover:text-wom-orange transition">
                  Middle East (Dubai)
                </Link>
              </li>
              <li>
                <Link href="/locations" className="hover:text-wom-orange transition">
                  India (Pune)
                </Link>
              </li>
              <li>
                <Link href="/locations" className="hover:text-wom-orange transition">
                  Asia Pacific (Singapore)
                </Link>
              </li>
              <li>
                <Link href="/locations" className="hover:text-wom-orange transition">
                  Brazil & South America
                </Link>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="pt-8 flex flex-col sm:flex-row justify-between items-center text-xs text-gray-500 gap-4">
          <p>© {new Date().getFullYear()} Worldwide Oilfield Machine (WOM). All rights reserved.</p>
          <div className="flex gap-6">
            <Link href="/privacy-policy" className="hover:text-gray-400 transition">
              Privacy Policy
            </Link>
            <Link href="/contact-us" className="hover:text-gray-400 transition">
              Contact
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
