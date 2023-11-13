import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';
import { RedocModule, RedocOptions } from '@juicyllama/nestjs-redoc';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors();
  app.useGlobalPipes(new ValidationPipe());
  app.enableShutdownHooks();
  app.getHttpAdapter().getInstance().disable('x-powered-by');
  app.use((req, res, next) => {
    res.header('Server', 'MarkdownNotepad API');
    next();
  });

  const config = new DocumentBuilder()
    .setTitle('Markdown Notepad API')
    .setDescription('API documentation for the Markdown Notepad app.')
    .setVersion('1.2.0')
    .addTag('auth', 'Authorization')
    .addTag('user', 'User information')
    .addTag('avatar', 'User avatars')
    .addTag('notes', 'Notes')
    .addTag('notetags', 'Note tags')
    .addTag('catalogs', 'Catalogs')
    .addTag('eventlogs', 'Event logs')
    .addTag('misc', 'Miscellaneous')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('docs', app, document);

  const redocOptions: RedocOptions = {
    title: 'Markdown Notepad API',
    logo: {
      url: 'http://localhost:3000/public/redoc_logo.png',
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
        tags: ['user', 'avatar'],
      },
      {
        name: 'Notes',
        tags: ['notes', 'notetags'],
      },
      {
        name: 'Catalogs',
        tags: ['catalogs'],
      },
      {
        name: 'Event logs',
        tags: ['eventlogs'],
      },
      {
        name: 'Miscellaneous',
        tags: ['misc'],
      },
    ],
  };
  await RedocModule.setup('/redoc', app, document, redocOptions);

  await app.listen(3000);
}

bootstrap();
