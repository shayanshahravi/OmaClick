# OmaClick

[English](README.md) · فارسی

**منوی راست‌کلیک دسکتاپ، به سبک ویندوز، برای دسکتاپ Omarchy.**

در بیشتر دسکتاپ‌های لینوکس، راست‌کلیک روی دسکتاپ خالی هیچ کاری نمی‌کند. OmaClick
یک منوی واقعی همان‌جا می‌سازد — ترمینال، فایل‌منیجر، والپیپر، تم، تنظیمات و قفل
صفحه — و آن را با استایل پاپ‌آپ خود Omarchy می‌کشد، تا بخشی از شل به‌نظر برسد نه
یک چیز چسبانده‌شده.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Lint](https://github.com/shayanshahravi/OmaClick/actions/workflows/lint.yml/badge.svg)](https://github.com/shayanshahravi/OmaClick/actions/workflows/lint.yml)
[![Omarchy compatible](https://img.shields.io/badge/Omarchy-Quattro-1f6feb.svg)](https://omarchy.org)
[![Release](https://img.shields.io/github/v/release/shayanshahravi/OmaClick?color=green)](https://github.com/shayanshahravi/OmaClick/releases)

![منوی راست‌کلیک OmaClick روی دسکتاپ خالی](preview.png)

## ویژگی‌ها

- **راست‌کلیک روی هر جای دسکتاپ** منو را دقیقاً زیر نشانگر ماوس باز می‌کند.
- **در محدوده‌ی صفحه می‌ماند**: اگر پایین فضای کافی نباشد، کارت بالای نشانگر باز
  می‌شود و هرگز از لبه‌ی صفحه بیرون نمی‌زند.
- **ظاهر بومی Omarchy**: کارت از رنگ‌های پاپ‌آپ، حاشیه و گردی گوشه‌ی تم فعال
  استفاده می‌کند و با عوض شدن تم بلافاصله هم‌راه می‌شود.
- **هماهنگ با زبان Omarchy**: برچسب ردیف‌ها از کاتالوگ `i18n/` خوانده می‌شود،
  پس نصب فرانسوی «Ouvrir un terminal» و مانند آن نشان می‌دهد. با عوض کردن زبان
  در Setup > Language، منو بدون ری‌استارت شل دوباره کشیده می‌شود.
- **سازگار با کیبورد**: کلید `Esc` آن را می‌بندد؛ کلیک بیرون منو هم همین کار را
  می‌کند (با focus grab در Hyprland).
- **ژست‌های دسکتاپ حفظ می‌شوند**: دابل‌کلیک روی والپیپر هنوز والپیپر را عوض
  می‌کند و دابل‌راست‌کلیک هنوز تم را.
- **پشتیبانی از چند مانیتور**: هر صفحه سطح خودش را دارد و منو روی همان صفحه‌ای
  باز می‌شود که کلیک کرده‌اید.
- **فقط یک فایل برای شخصی‌سازی**: آیتم‌های منو در
  [`config/MenuEntries.js`](config/MenuEntries.js) هستند.

آیتم‌های پیش‌فرض:

| آیتم                 | کاری که انجام می‌دهد                            |
| -------------------- | ----------------------------------------------- |
| Open Terminal        | `omarchy-launch-terminal`                        |
| Open Files           | `nautilus`                                       |
| Change Wallpaper…    | `omarchy-theme-bg-switcher` + `omarchy-theme-bg-set` |
| Change Theme…        | `omarchy-theme-switcher` + `omarchy-theme-set`   |
| Settings…            | `omarchy-shell omasettings toggle`               |
| Lock Screen          | `omarchy-system-lock`                            |

## پیش‌نیازها

- **Omarchy** (شل Quattro، مانیفست پلاگین با `schemaVersion: 1`).
- `nautilus` برای ردیف *Open Files* — اگر فایل‌منیجر دیگری دارید همان آیتم را
  ویرایش کنید.
- هیچ پکیج اضافه، هیچ سرویس پس‌زمینه و هیچ کلید ترکیبی Hyprland لازم نیست.

## نصب

با مدیر پلاگین Omarchy:

```sh
omarchy plugin add https://github.com/shayanshahravi/OmaClick.git --enable
```

یا از داخل مخزن با اسکریپت نصب، که نسخه‌ی دستیِ قبلی منو را هم بازنشسته می‌کند:

```sh
git clone https://github.com/shayanshahravi/OmaClick.git
cd OmaClick
./install.sh
```

در هر دو حالت پلاگین در مسیر
`~/.config/omarchy/plugins/io.github.shayanshahravi.omaclick/` نصب و بلافاصله
فعال می‌شود. نیازی به ری‌استارت شل نیست؛ روی دسکتاپ راست‌کلیک کنید.

## استفاده

- **راست‌کلیک روی دسکتاپ** → منو زیر نشانگر باز می‌شود.
- **کلیک چپ روی یک ردیف** → دستور آن اجرا و منو بسته می‌شود.
- **`Esc` یا کلیک بیرون** → منو بسته می‌شود.
- **دابل‌کلیک روی والپیپر** → والپیپر بعدی.
- **دابل‌راست‌کلیک روی والپیپر** → تم بعدی.

## شخصی‌سازی

فایل `config/MenuEntries.js` داخل پلاگین نصب‌شده را ویرایش کنید:

```sh
$EDITOR ~/.config/omarchy/plugins/io.github.shayanshahravi.omaclick/config/MenuEntries.js
```

هر ردیف یا یک دستور است یا یک جداکننده:

```js
var entries = [
  { key: "menu.terminal", label: "Open Terminal", command: "omarchy-launch-terminal" },
  { separator: true },
  { label: "اسکریپت من", command: "~/bin/my-script" }
]
```

`key` کلید کاتالوگ در `i18n/<زبان>.json` است و هنگام کشیدن ردیف خوانده می‌شود،
پس ردیف با زبان Omarchy هم‌راه می‌شود. `label` متن جایگزین است: وقتی کاتالوگ
فعال کلیدی برای `key` نداشته باشد همان نمایش داده می‌شود، و برای ردیف‌های بدون
`key` تنها متن نمایش‌داده‌شده است.

بعد شل را دوباره بارگذاری کنید:

```sh
omarchy-shell shell rescanPlugins
```

دستورها با `Util.execDetached` و به‌صورت جدا از شل اجرا می‌شوند؛ یعنی با
کاربر و محیط خودتان، دقیقاً مثل اجرا کردنشان در ترمینال.

## حذف نصب

```sh
omarchy plugin remove io.github.shayanshahravi.omaclick
```

یا برای برگرداندن منوی دستیِ قبلی که `install.sh` بازنشسته کرده بود:

```sh
./uninstall.sh --restore-legacy
```

نسخه‌های پشتیبان در `~/.local/state/omaclick/backups/` نگه داشته می‌شوند؛ هیچ
چیزی بیرون از پوشه‌ی پلاگین تغییر نمی‌کند، پس حذف آن تنظیمات شما را دست نمی‌زند.

## چطور کار می‌کند

OmaClick یک پلاگین از نوع `service` است: فایل `Service.qml` داخل پروسه‌ی در حال
اجرای `omarchy-shell` (یعنی Quickshell) بارگذاری می‌شود.

- یک سطح شفاف تمام‌صفحه در لایه‌ی **bottom** که بعد از سطح والپیپر ساخته می‌شود،
  ورودی ماوس روی دسکتاپ خالی را می‌گیرد، بدون اینکه پنجره‌ها یا ویجت‌های لایه‌ی
  پایین را بپوشاند.
- یک سطح دوم در لایه‌ی **overlay** که خود کارت را به اندازه‌ی منو می‌کشد و یک
  focus grab دارد تا کلیک بیرون آن را ببندد.
- دستورها با `Util.execDetached` اجرا می‌شوند، پس شل هیچ‌وقت بلاک نمی‌شود.

این پلاگین پروسه‌ی دوم Quickshell باز نمی‌کند و فایل‌های تنظیمات Hyprland را
دست نمی‌زند.

## مجوز

[MIT](LICENSE) © Shayan Shahravi
