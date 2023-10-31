import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';
import { RedocModule, RedocOptions } from '@juicyllama/nestjs-redoc';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: false });
  app.useGlobalPipes(new ValidationPipe());
  app.enableShutdownHooks();
  app.getHttpAdapter().getInstance().disable('x-powered-by');
  app.use((req, res, next) => {
    res.header('Server', 'MarkdownNotepad API');
    next();
  });

  const config = new DocumentBuilder()
    .setTitle('Markdown Notepad API')
    .setVersion('1.0')
    .addTag('user')
    .addTag('auth')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('docs', app, document);

  const redocOptions: RedocOptions = {
    title: 'Markdown Notepad API',
    logo: {
      url: 'http://localhost:3000/public/icon.png',
      backgroundColor: '#F0F0F0',
      altText: 'Markdown Notepad API',
    },
    favicon: 'http://localhost:3000/public/icon.png',
    sortPropsAlphabetically: true,
    hideDownloadButton: false,
    hideHostname: false,
    redocVersion: 'next',
    tagGroups: [
      {
        name: 'Authorization',
        tags: ['auth'],
      },
      {
        name: 'User',
        tags: ['user'],
      },
    ],
  };
  await RedocModule.setup('/redoc', app, document, redocOptions);

  await app.listen(3000);
}

bootstrap();
