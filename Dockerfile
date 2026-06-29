# 1. استخدام نسخة PHP الرسمية المدمجة مع سيرفر أباتشي
FROM php:8.1-apache

# 2. تثبيت المكتبات وتحديث النظام لدعم قواعد البيانات (MySQL / MariaDB)
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-install mysqli pdo pdo_mysql

# 3. تفعيل مود الـ Rewrite في أباتشي للروابط الذكية
RUN a2enmod rewrite

# 4. نسخ ملفات المشروع الحالية (مثل index.php) إلى مجلد سيرفر أباتشي الافتراضي
COPY . /var/www/html/

# 5. فتح المنفذ 8080 (وهو المنفذ الإلزامي الذي يطلبه Google Cloud Run)
EXPOSE 8080

# 6. تعديل إعدادات أباتشي الداخلية ليتحول من المنفذ الافتراضي 80 إلى المنفذ 8080
RUN sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# 7. أمر تشغيل السيرفر في الخلفية بشكل مستمر
CMD ["apache2-foreground"]
