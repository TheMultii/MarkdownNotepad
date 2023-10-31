import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';

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

  await app.listen(3000);
}

bootstrap();
