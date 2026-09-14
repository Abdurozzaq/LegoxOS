const translations = {
    en: {
        version: "Version 1.0 (Developer Edition)",
        welcome_title: "Welcome to LegoxOS",
        welcome_subtitle: "The ultimate, ready-to-use Linux distribution for Software Engineers.",
        what_is_title: "What is LegoxOS?",
        what_is_desc: "LegoxOS is a customized Linux distribution built specifically for developers. It eliminates the hassle of setting up development environments by baking all essential tools, languages, and IDEs directly into the OS. Out of the box, you get instant access to Node.js, Python, Go, PHP, Docker, and various modern GUI applications.",
        tools_title: "Developer Tools (CLI)",
        tools_subtitle: "Modern, fast, and pre-configured command-line tools.",
        fnm_desc: "Handles multiple Node.js versions.",
        pyenv_desc: "Easily switch between multiple Python versions.",
        lazydocker_desc: "A simple terminal UI for both docker and docker-compose.",
        golang_desc: "Easily switch between multiple Go versions using GVM.",
        php_desc: "Switch between installed PHP versions using update-alternatives.",
        apps_title: "Pre-installed Apps",
        apps_subtitle: "Ready to use graphical applications.",
        vscode_desc: "The world's most popular code editor, pre-configured and ready to use.",
        dbeaver_desc: "Universal database tool for developers and database administrators.",
        postman_desc: "API development platform for building and using APIs.",
        onlyoffice_desc: "Powerful and complete office suite fully compatible with MS Office formats.",
        browsers_desc: "Modern and fast web browsers (Chromium and Firefox) for browsing and testing.",
        media_desc: "Discord for communication, VLC for media playback.",
        portainer_title: "Portainer (Database Manager)",
        portainer_subtitle: "Manage your local databases visually through Docker.",
        portainer_what_title: "Why Portainer?",
        portainer_what_desc: "Instead of installing MySQL, PostgreSQL, or Redis manually on your host machine, LegoxOS uses Portainer to manage them inside Docker containers. This keeps your system clean and allows you to run multiple versions easily.",
        portainer_how_title: "Deploy a container",
        portainer_step1: "Portainer lets you deploy a standalone container from the default templates list. From the menu expand Templates then select Application or Custom (depending on the container). On the Application templates page you can choose to display only Container templates using the Type dropdown.",
        portainer_step2: "Then, select the container template you want to deploy. Define a name, a network, port mapping and volumes, and toggle Enable access control on if needed.",
        portainer_step3: "You can also make changes to container settings such as port and volume mapping, host file entries, labels and the hostname by clicking Show advanced options.",
        portainer_step4: "Once you have configured the container, click Deploy the container.",
        autostart_title: "Disabling Autostart",
        autostart_desc: "This documentation opens automatically on startup by default. If you want to disable it, simply run this command in your terminal:",
        official_docs: "Official Docs ↗"
    },
    id: {
        version: "Versi 1.0 (Edisi Developer)",
        welcome_title: "Selamat Datang di LegoxOS",
        welcome_subtitle: "Distribusi Linux mutakhir yang siap pakai untuk Software Engineer.",
        what_is_title: "Apa itu LegoxOS?",
        what_is_desc: "LegoxOS adalah sistem operasi Linux khusus yang dibangun untuk developer. OS ini menghilangkan kerumitan mengatur environment dengan menyertakan semua tools, bahasa pemrograman, dan IDE langsung di dalamnya. Anda langsung mendapatkan akses instan ke Node.js, Python, Go, PHP, Docker, dan berbagai aplikasi GUI modern.",
        tools_title: "Alat Developer (CLI)",
        tools_subtitle: "Tool berbasis command-line yang modern, cepat, dan sudah dikonfigurasi.",
        fnm_desc: "Mengatur banyak versi Node.js dengan mudah.",
        pyenv_desc: "Beralih antar berbagai versi Python dengan praktis.",
        lazydocker_desc: "Antarmuka terminal yang simpel untuk docker dan docker-compose.",
        golang_desc: "Beralih antar berbagai versi Go dengan mudah menggunakan GVM.",
        php_desc: "Beralih antar versi PHP yang terinstal menggunakan update-alternatives.",
        apps_title: "Aplikasi Bawaan",
        apps_subtitle: "Aplikasi grafis (GUI) yang siap digunakan.",
        vscode_desc: "Code editor paling populer di dunia, sudah dikonfigurasi dan siap pakai.",
        dbeaver_desc: "Aplikasi universal untuk developer dan admin dalam mengelola database.",
        postman_desc: "Platform pengembangan API untuk membangun dan menguji API.",
        onlyoffice_desc: "Aplikasi perkantoran lengkap dan canggih yang kompatibel dengan format MS Office.",
        browsers_desc: "Browser web modern dan cepat (Chromium dan Firefox) untuk browsing dan testing.",
        media_desc: "Discord untuk komunikasi, VLC untuk memutar media.",
        portainer_title: "Portainer (Manajer Database)",
        portainer_subtitle: "Kelola database lokal Anda secara visual melalui Docker.",
        portainer_what_title: "Kenapa Portainer?",
        portainer_what_desc: "Daripada menginstal MySQL, PostgreSQL, atau Redis secara manual di komputer Anda, LegoxOS menggunakan Portainer untuk mengelolanya di dalam kontainer Docker. Ini menjaga sistem Anda tetap bersih dan memudahkan Anda menjalankan berbagai versi database.",
        portainer_how_title: "Men-deploy Container",
        portainer_step1: "Portainer memungkinkan Anda men-deploy container mandiri dari daftar template bawaan. Dari menu, perluas Templates lalu pilih Application atau Custom. Pada halaman Application templates, Anda dapat memfilter template tipe Container saja lewat dropdown Type.",
        portainer_step2: "Kemudian, pilih template container yang ingin di-deploy. Tentukan nama, jaringan, port mapping, dan volume, serta aktifkan Enable access control jika diperlukan.",
        portainer_step3: "Anda juga dapat mengubah pengaturan container seperti port, host file, label, dan hostname dengan mengklik Show advanced options.",
        portainer_step4: "Setelah container dikonfigurasi, klik Deploy the container.",
        autostart_title: "Mematikan Autostart",
        autostart_desc: "Dokumentasi ini otomatis terbuka setiap kali komputer menyala. Jika kamu ingin mematikannya, cukup jalankan perintah ini di terminal:",
        official_docs: "Dokumentasi Resmi ↗"
    }
};

let currentLang = 'en';

function setLanguage(lang) {
    currentLang = lang;
    
    // Update active button state
    document.getElementById('btn-en').classList.toggle('active', lang === 'en');
    document.getElementById('btn-id').classList.toggle('active', lang === 'id');

    // Translate all elements with data-i18n attribute
    const elements = document.querySelectorAll('[data-i18n]');
    elements.forEach(el => {
        const key = el.getAttribute('data-i18n');
        if (translations[lang][key]) {
            el.innerHTML = translations[lang][key];
        }
    });
}

// Navigation Logic
const navItems = document.querySelectorAll('nav li');
const sections = document.querySelectorAll('main section');

navItems.forEach(item => {
    item.addEventListener('click', () => {
        // Remove active class from all nav items
        navItems.forEach(nav => nav.classList.remove('active'));
        // Add active class to clicked nav item
        item.classList.add('active');

        // Hide all sections
        sections.forEach(section => section.classList.remove('active-section'));
        
        // Show target section
        const targetId = item.getAttribute('data-target');
        document.getElementById(targetId).classList.add('active-section');
    });
});

// Event Listeners for Language Buttons
document.getElementById('btn-en').addEventListener('click', () => setLanguage('en'));
document.getElementById('btn-id').addEventListener('click', () => setLanguage('id'));

// Initialize with default language
setLanguage('en');
