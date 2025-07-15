# Menggunakan base image PHP Apache dengan versi yang sesuai
FROM php:8.2-apache

# Instal ekstensi PHP yang dibutuhkan oleh CodeIgniter
RUN docker-php-ext-install pdo pdo_mysql mysqli opcache \
    && docker-php-ext-enable opcache

# Menginstal Composer (opsional, jika Anda menggunakan Composer)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Mengatur working directory di dalam container
WORKDIR /var/www/html

# Menyalin semua file proyek Anda ke dalam container
COPY . .

# Pastikan folder cache CodeIgniter bisa ditulis
RUN mkdir -p application/cache application/logs \
    && chown -R www-data:www-data application/cache \
    && chown -R www-data:www-data application/logs \
    && chmod -R 775 application/cache \
    && chmod -R 775 application/logs

# Menginstal dependensi Composer jika ada (misalnya: spark-packages/codeigniter-restserver)
# RUN composer install --no-dev --optimize-autoloader

# Mengekspos port Apache
EXPOSE 80

# Perintah default untuk Apache
CMD ["apache2-foreground"]