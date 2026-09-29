import React from "react";
import Link from "next/link";
import { Metadata } from "next";
import { MapPin, Phone, Mail, Clock, Send } from "lucide-react";

export const metadata: Metadata = {
  title: "Contact Us - Worldwide Oilfield Machine (WOM)",
  description: "Connect with WOM global headquarters in Houston, Texas or regional sales and service hubs worldwide.",
};

export default function ContactUsPage() {
  return (
    <div className="py-12 bg-gray-50 min-h-screen">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-xs text-gray-500 mb-4">
          <Link href="/" className="hover:text-wom-orange">Home</Link> / <span className="text-gray-900 font-semibold">Contact Us</span>
        </div>

        <div className="mb-12">
          <span className="text-xs font-bold uppercase tracking-widest text-wom-orange mb-2 block">
            Get in touch
          </span>
          <h1 className="text-4xl font-black text-gray-900 mb-4">
            Connect with WOM Application Engineering & Sales
          </h1>
          <p className="text-gray-600 max-w-3xl leading-relaxed">
            Whether you require custom equipment specifications, urgent field service support, or tender quotations, our teams are available 24/7.
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12">
          {/* Contact Details & Global Offices */}
          <div className="lg:col-span-5 space-y-6">
            {/* Headquarters Card */}
            <div className="bg-white border border-gray-200 rounded-2xl p-6 shadow-sm">
              <span className="text-[11px] font-bold uppercase tracking-wider text-wom-orange bg-orange-50 px-2.5 py-1 rounded inline-block mb-3">
                Global Headquarters
              </span>
              <h3 className="font-bold text-gray-900 text-lg mb-3">
                Worldwide Oilfield Machine Inc.
              </h3>
              <div className="space-y-3 text-xs text-gray-600">
                <div className="flex items-start gap-2.5">
                  <MapPin className="w-4 h-4 text-wom-orange shrink-0 mt-0.5" />
                  <span>11809 Canemont St, Houston, TX 77035, USA</span>
                </div>
                <div className="flex items-center gap-2.5">
                  <Phone className="w-4 h-4 text-wom-orange shrink-0" />
                  <a href="tel:+18328028000" className="hover:text-wom-orange transition">
                    +1 (832) 802-8000
                  </a>
                </div>
                <div className="flex items-center gap-2.5">
                  <Mail className="w-4 h-4 text-wom-orange shrink-0" />
                  <a href="mailto:info@womgroup.com" className="hover:text-wom-orange transition">
                    info@womgroup.com
                  </a>
                </div>
                <div className="flex items-center gap-2.5">
                  <Clock className="w-4 h-4 text-wom-orange shrink-0" />
                  <span>Monday - Friday: 8:00 AM - 5:00 PM CST</span>
                </div>
              </div>
            </div>

            {/* Regional Hubs Quick Contacts */}
            <div className="bg-white border border-gray-200 rounded-2xl p-6 shadow-sm">
              <h3 className="font-bold text-gray-900 text-sm mb-4 uppercase tracking-wider">
                Regional Hubs
              </h3>
              <div className="space-y-4 text-xs text-gray-600">
                <div>
                  <div className="font-bold text-gray-900">Middle East (Dubai)</div>
                  <div>Jebel Ali Free Zone, Dubai, UAE</div>
                  <div className="text-gray-500">Phone: +971 4 810 5000</div>
                </div>
                <div className="border-t border-gray-100 pt-3">
                  <div className="font-bold text-gray-900">United Kingdom (Aberdeen)</div>
                  <div>Howemoss Drive, Kirkhill Industrial Estate, Aberdeen</div>
                  <div className="text-gray-500">Phone: +44 1224 771 888</div>
                </div>
                <div className="border-t border-gray-100 pt-3">
                  <div className="font-bold text-gray-900">India (Pune HQ)</div>
                  <div>Gat No. 1167/2, Pirangut, Mulshi, Pune, India</div>
                  <div className="text-gray-500">Phone: +91 20 6674 8000</div>
                </div>
              </div>
            </div>
          </div>

          {/* Inquiry Form */}
          <div className="lg:col-span-7">
            <div className="bg-white border border-gray-200 rounded-2xl p-8 shadow-sm">
              <h2 className="text-2xl font-bold text-gray-900 mb-2">
                Send an Inquiry or RFP
              </h2>
              <p className="text-xs text-gray-500 mb-6">
                Fill in your details below and a WOM sales engineer will respond within 24 hours.
              </p>

              <form className="space-y-4">
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-semibold text-gray-700 mb-1">
                      Full Name *
                    </label>
                    <input
                      type="text"
                      required
                      placeholder="John Doe"
                      className="w-full text-xs px-3.5 py-2.5 rounded-lg border border-gray-300 focus:outline-none focus:border-wom-orange"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-semibold text-gray-700 mb-1">
                      Work Email *
                    </label>
                    <input
                      type="email"
                      required
                      placeholder="john.doe@company.com"
                      className="w-full text-xs px-3.5 py-2.5 rounded-lg border border-gray-300 focus:outline-none focus:border-wom-orange"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-semibold text-gray-700 mb-1">
                      Company Name *
                    </label>
                    <input
                      type="text"
                      required
                      placeholder="Energy Operations Inc."
                      className="w-full text-xs px-3.5 py-2.5 rounded-lg border border-gray-300 focus:outline-none focus:border-wom-orange"
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-semibold text-gray-700 mb-1">
                      Phone Number
                    </label>
                    <input
                      type="tel"
                      placeholder="+1 (555) 000-0000"
                      className="w-full text-xs px-3.5 py-2.5 rounded-lg border border-gray-300 focus:outline-none focus:border-wom-orange"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">
                    Subject / Area of Interest *
                  </label>
                  <select className="w-full text-xs px-3.5 py-2.5 rounded-lg border border-gray-300 focus:outline-none focus:border-wom-orange bg-white">
                    <option>Product Quotation / RFQ</option>
                    <option>Technical Specifications / Drawings</option>
                    <option>Field Service & Repair</option>
                    <option>Customer Asset Management</option>
                    <option>Careers & Employment</option>
                    <option>Other Inquiry</option>
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-semibold text-gray-700 mb-1">
                    Project Details / Requirements *
                  </label>
                  <textarea
                    rows={5}
                    required
                    placeholder="Please include working pressures, sizes, API specifications, and service requirements..."
                    className="w-full text-xs px-3.5 py-2.5 rounded-lg border border-gray-300 focus:outline-none focus:border-wom-orange"
                  />
                </div>

                <button
                  type="submit"
                  className="w-full bg-wom-orange hover:bg-wom-orangeHover text-white py-3 rounded-lg text-xs font-bold transition shadow flex items-center justify-center gap-2"
                >
                  <Send className="w-4 h-4" />
                  Submit Inquiry
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
