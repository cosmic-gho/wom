import { NextResponse } from 'next/server';
import { supabase, isSupabaseConfigured } from '@/lib/supabase';
import nodemailer from 'nodemailer';
import fs from 'fs';
import path from 'path';

const INQUIRIES_FILE = path.join(process.cwd(), 'content', 'inquiries.json');

function readLocalInquiries() {
    if (!fs.existsSync(INQUIRIES_FILE)) return [];
    try {
        return JSON.parse(fs.readFileSync(INQUIRIES_FILE, 'utf8'));
    } catch (e) {
        return [];
    }
}

function writeLocalInquiries(data: any[]) {
    try {
        fs.writeFileSync(INQUIRIES_FILE, JSON.stringify(data, null, 2), 'utf8');
        return true;
    } catch (e) {
        return false;
    }
}

export async function POST(request: Request) {
    try {
        const body = await request.json();
        const { name, email, company, phone, subject, message } = body;

        if (!name || !email || !message) {
            return NextResponse.json(
                { success: false, error: 'Name, email, and message are required fields' },
                { status: 400 }
            );
        }

        const newInquiry = {
            id: Date.now(),
            name,
            email,
            company: company || '',
            phone: phone || '',
            subject: subject || 'New Website Inquiry',
            message,
            status: 'unread',
            created_at: new Date().toISOString(),
        };

        // 1. Save to Supabase if configured
        if (isSupabaseConfigured() && supabase) {
            const { error: dbError } = await supabase.from('inquiries').insert([
                {
                    name,
                    email,
                    company: company || '',
                    phone: phone || '',
                    subject: subject || 'New Website Inquiry',
                    message,
                    status: 'unread',
                },
            ]);
            if (dbError) console.error('Supabase Inquiry Error:', dbError);
        }

        // Always update local file store as fallback / sync
        const local = readLocalInquiries();
        local.unshift(newInquiry);
        writeLocalInquiries(local);

        // 2. Trigger SMTP Email Notification to Admin if SMTP configured
        const smtpHost = process.env.SMTP_HOST;
        const smtpPort = process.env.SMTP_PORT ? parseInt(process.env.SMTP_PORT, 10) : 587;
        const smtpUser = process.env.SMTP_USER;
        const smtpPass = process.env.SMTP_PASS;
        const adminEmail = process.env.ADMIN_NOTIFICATION_EMAIL || process.env.ADMIN_EMAIL || 'admin@womgroup.com';

        if (smtpHost && smtpUser && smtpPass) {
            try {
                const transporter = nodemailer.createTransport({
                    host: smtpHost,
                    port: smtpPort,
                    secure: smtpPort === 465,
                    auth: {
                        user: smtpUser,
                        pass: smtpPass,
                    },
                });

                await transporter.sendMail({
                    from: `"WOM Group Contact Form" <${smtpUser}>`,
                    to: adminEmail,
                    replyTo: email,
                    subject: `[New Lead] ${subject || 'Website Inquiry from ' + name}`,
                    html: `
                        <div style="font-family: sans-serif; padding: 20px; color: #1e293b;">
                            <h2 style="color: #2563eb;">New Website Contact Inquiry</h2>
                            <p><strong>Name:</strong> ${name}</p>
                            <p><strong>Email:</strong> ${email}</p>
                            <p><strong>Company:</strong> ${company || 'N/A'}</p>
                            <p><strong>Phone:</strong> ${phone || 'N/A'}</p>
                            <p><strong>Subject:</strong> ${subject || 'General Inquiry'}</p>
                            <hr style="border: 0; border-top: 1px solid #e2e8f0; margin: 20px 0;" />
                            <h4 style="margin-bottom: 5px;">Message:</h4>
                            <p style="background-color: #f8fafc; padding: 15px; border-radius: 8px; border: 1px solid #e2e8f0;">${message}</p>
                        </div>
                    `,
                });
            } catch (smtpErr) {
                console.error('SMTP Email Notification Error:', smtpErr);
            }
        }

        return NextResponse.json({
            success: true,
            message: 'Inquiry submitted successfully. Our team will get back to you shortly.',
        });
    } catch (error: any) {
        console.error('Contact API Error:', error);
        return NextResponse.json({ success: false, error: 'Internal server error' }, { status: 500 });
    }
}
