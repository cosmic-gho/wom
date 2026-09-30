import { NextResponse } from 'next/server';
import { v2 as cloudinary } from 'cloudinary';
import fs from 'fs';
import path from 'path';

const cloudName = process.env.CLOUDINARY_CLOUD_NAME || process.env.NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME;
const apiKey = process.env.CLOUDINARY_API_KEY;
const apiSecret = process.env.CLOUDINARY_API_SECRET;

const isCloudinaryConfigured = Boolean(cloudName && apiKey && apiSecret);

if (isCloudinaryConfigured) {
    cloudinary.config({
        cloud_name: cloudName,
        api_key: apiKey,
        api_secret: apiSecret,
        secure: true,
    });
}

const PUBLIC_UPLOADS_DIR = path.join(process.cwd(), 'public', 'uploads');

export async function POST(request: Request) {
    try {
        const formData = await request.formData();
        const file = formData.get('file') as File | null;
        const folder = (formData.get('folder') as string) || 'womgroup';

        if (!file) {
            return NextResponse.json({ success: false, error: 'No file provided' }, { status: 400 });
        }

        const arrayBuffer = await file.arrayBuffer();
        const buffer = Buffer.from(arrayBuffer);

        // If Cloudinary is configured, upload to Cloudinary CDN
        if (isCloudinaryConfigured) {
            const base64Data = `data:${file.type};base64,${buffer.toString('base64')}`;

            const uploadResult = await new Promise<any>((resolve, reject) => {
                cloudinary.uploader.upload(
                    base64Data,
                    {
                        folder: folder,
                        resource_type: 'auto',
                    },
                    (error, result) => {
                        if (error) reject(error);
                        else resolve(result);
                    }
                );
            });

            return NextResponse.json({
                success: true,
                provider: 'cloudinary',
                url: uploadResult.secure_url,
                public_id: uploadResult.public_id,
                format: uploadResult.format,
                width: uploadResult.width,
                height: uploadResult.height,
                sizeBytes: uploadResult.bytes,
                message: 'Uploaded successfully to Cloudinary',
            });
        }

        // Fallback: Save to local public/uploads directory
        if (!fs.existsSync(PUBLIC_UPLOADS_DIR)) {
            fs.mkdirSync(PUBLIC_UPLOADS_DIR, { recursive: true });
        }

        const safeFilename = `${Date.now()}-${file.name.replace(/[^a-zA-Z0-9.-]/g, '_')}`;
        const filePath = path.join(PUBLIC_UPLOADS_DIR, safeFilename);

        fs.writeFileSync(filePath, buffer);

        const publicUrl = `/uploads/${safeFilename}`;

        return NextResponse.json({
            success: true,
            provider: 'local',
            url: publicUrl,
            filename: safeFilename,
            sizeBytes: buffer.length,
            message: 'Uploaded locally (Configure Cloudinary keys in .env for CDN hosting)',
        });
    } catch (error: any) {
        console.error('File Upload Error:', error);
        return NextResponse.json(
            { success: false, error: error.message || 'Failed to upload file' },
            { status: 500 }
        );
    }
}
