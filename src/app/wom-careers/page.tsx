import React from "react";
import { getPageBySlug } from "@/lib/data";
import Link from "next/link";
import { Metadata } from "next";
import { Briefcase, Users, HeartHandshake, CheckCircle2 } from "lucide-react";

export const metadata: Metadata = {
  title: "Careers & Opportunities - Worldwide Oilfield Machine (WOM)",
  description: "Join the global engineering and manufacturing teams at Worldwide Oilfield Machine.",
};

export default function CareersPage() {
  const page = getPageBySlug("wom-careers");

  return (
    <div className="py-12 bg-white min-h-screen">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-xs text-gray-500 mb-4">
          <Link href="/" className="hover:text-wom-orange">Home</Link> / <span>Company</span> / <span className="text-gray-900 font-semibold">Careers</span>
        </div>

        <div className="mb-12">
          <span className="text-xs font-bold uppercase tracking-widest text-wom-orange mb-2 block">
            Work with us
          </span>
          <h1 className="text-4xl font-black text-gray-900 mb-4">
            Build Your Career in Global Energy Engineering
          </h1>
          <p className="text-gray-600 leading-relaxed max-w-3xl">
            WOM offers rewarding careers across design engineering, precision machining, quality control, metallurgy, operations, and international sales.
          </p>
        </div>

        {/* Benefits Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-16">
          <div className="bg-gray-50 p-6 rounded-2xl border border-gray-200">
            <Users className="w-8 h-8 text-wom-orange mb-4" />
            <h3 className="font-bold text-gray-900 mb-2">Global Collaboration</h3>
            <p className="text-xs text-gray-600 leading-relaxed">
              Work alongside multidisciplinary engineering teams in Houston, Scotland, Dubai, and India.
            </p>
          </div>
          <div className="bg-gray-50 p-6 rounded-2xl border border-gray-200">
            <HeartHandshake className="w-8 h-8 text-wom-orange mb-4" />
            <h3 className="font-bold text-gray-900 mb-2">Comprehensive Growth</h3>
            <p className="text-xs text-gray-600 leading-relaxed">
              Continuous technical training, API standard mastery, and internal leadership pathways.
            </p>
          </div>
          <div className="bg-gray-50 p-6 rounded-2xl border border-gray-200">
            <Briefcase className="w-8 h-8 text-wom-orange mb-4" />
            <h3 className="font-bold text-gray-900 mb-2">World-Class Facilities</h3>
            <p className="text-xs text-gray-600 leading-relaxed">
              State-of-the-art CNC machine centers, advanced metallurgy testing labs, and high-pressure test bays.
            </p>
          </div>
        </div>

        {page?.contentHtml && (
          <div className="border-t border-gray-200 pt-8 mb-12">
            <div
              className="wp-content-render prose prose-orange max-w-none"
              dangerouslySetInnerHTML={{ __html: page.contentHtml }}
            />
          </div>
        )}

        <div className="bg-wom-dark text-white rounded-2xl p-8 text-center space-y-4">
          <h2 className="text-2xl font-bold">Ready to Join WOM?</h2>
          <p className="text-xs text-gray-300 max-w-xl mx-auto">
            Submit your resume and credentials directly to our Human Resources team.
          </p>
          <a
            href="mailto:careers@womgroup.com"
            className="inline-block bg-wom-orange hover:bg-wom-orangeHover text-white px-8 py-3 rounded-full text-xs font-bold transition shadow"
          >
            Email HR: careers@womgroup.com
          </a>
        </div>
      </div>
    </div>
  );
}
