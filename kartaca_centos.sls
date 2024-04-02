sudo yum install nginx //nginx yükler

sudo systemctl enable nginx // nginx'i başlatır.

sudo yum install php php-fpm php-mysql // php ve gerekli paketleri kurar.
/* etc/nginx/nginx.conf dosyası içine gidilip server bloğuna bu ayarlar yapıştırılmalıdır.
server {
    listen 80;
    server_name your_domain.com; # Domain adınızı buraya girin
    root /var/www/wordpress2024; # WordPress kurulumunun yolu

    location / {
        index index.php index.html index.htm;
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
    }

    location ~ /\.ht {
        deny all;
    }
}
      */
	  
wget -P /tmp https://wordpress.org/latest.tar.gz
sudo tar -xzvf /tmp/latest.tar.gz -C /var/www/
sudo mv /var/www/wordpress /var/www/wordpress2024 // WordPress indirir ve kurar.

include /etc/nginx/conf.d/*.conf; //etc/nginx/nginx.conf dosyasına bu ayar dahil edilmelidir. Nginx.conf dosyasını otomatik reload eder.

//Sonra, etc/nginx/conf.d dizininde yeni bir dosya açılıp(example: wordpress.conf) ve içeriği aşağıdaki şekilde değiştirilmelidir:

    location / {
    try_files $uri $uri/ /index.php?$args;
}

//wp-config.php ayarları:

/* MySQL veritabanı bilgileri girilmelidir.
define( 'DB_NAME', 'veritabani_adi' );
define( 'DB_USER', 'kullanici_adi' );
define( 'DB_PASSWORD', 'sifre' );
define( 'DB_HOST', 'localhost' );
define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', '' );

// Salt ve key'leri güncellemek için WordPress'in ürettiği rastgele değerler kullanılır.
define( 'AUTH_KEY',         'rastgele_deger' );
define( 'SECURE_AUTH_KEY',  'rastgele_deger' );
define( 'LOGGED_IN_KEY',    'rastgele_deger' );
define( 'NONCE_KEY',        'rastgele_deger' );
define( 'AUTH_SALT',        'rastgele_deger' );
define( 'SECURE_AUTH_SALT', 'rastgele_deger' );
define( 'LOGGED_IN_SALT',   'rastgele_deger' );
define( 'NONCE_SALT',       'rastgele_deger' );
// WordPress secret ve key'lerini almak için API kullanımı:
$wp_salt = file_get_contents('https://api.wordpress.org/secret-key/1.1/salt/');
$wp_salt = preg_replace('/\s+/', '', $wp_salt);
eval($wp_salt);
// SSL ayarları aşağıdaki gibi ayarlanır:
define('FORCE_SSL_ADMIN', true);
if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
    $_SERVER['HTTPS']='on'; */
                                             
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt //SSL ayarları.Sonra bu ayarlar /etc/nginx/conf.d/ dizinindeki Nginx yapılandırma dosyasına eklenir.

0 0 1 * * systemctl restart nginx // crontab-e komutu kullanılarak crontab dosyasını düzenleyin ve içine bu satırı ekleyin.

//etc/logrotate.d/nginx dosyasını açın ve içine şu yapılandırmayı ekleyin:
 /* /var/log/nginx/*.log {
    hourly
    rotate 10
    compress
    delaycompress
    missingok
    notifempty
    create 0640 nginx nginx
    postrotate
        /bin/systemctl reload nginx > /dev/null 2>&1
    endscript
} */


	  