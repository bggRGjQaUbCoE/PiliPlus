# This spec file expects _version, _build_date, _commit_hash, and _commit_number to be defined via rpmbuild --define
Name:           piliplus
Version:        %{_version}
Release:        1%{?dist}
Summary:        PiliPlus Linux Version
License:        GPL-3.0-or-later
Source0:        piliplus-%{_version}.tar.gz
Requires:       desktop-file-utils, hicolor-icon-theme

%description
使用 Flutter 开发的 BiliBili 第三方客户端

%prep
%setup -q -n piliplus-%{_version}

%build

%install
mkdir -p %{buildroot}/opt/PiliPlus
cp -r bundle/* %{buildroot}/opt/PiliPlus/

# 二进制权限与命令行入口
chmod 755 %{buildroot}/opt/PiliPlus/piliplus
mkdir -p %{buildroot}/usr/bin
ln -sf /opt/PiliPlus/piliplus %{buildroot}/usr/bin/piliplus

# 桌面集成
mkdir -p %{buildroot}/usr/share/applications
install -m 644 assets/com.example.piliplus.desktop %{buildroot}/usr/share/applications/com.example.piliplus.desktop

mkdir -p %{buildroot}/usr/share/icons/hicolor/512x512/apps
install -m 644 assets/piliplus.png %{buildroot}/usr/share/icons/hicolor/512x512/apps/piliplus.png

%post
update-desktop-database -q || true
gtk-update-icon-cache -q -t -f %{_datadir}/icons/hicolor || true

%postun
update-desktop-database -q || true
gtk-update-icon-cache -q -t -f %{_datadir}/icons/hicolor || true

%files
/opt/PiliPlus
/usr/bin/piliplus
/usr/share/applications/com.example.piliplus.desktop
/usr/share/icons/hicolor/512x512/apps/piliplus.png

%changelog
* %{_build_date} GitHub Action - %{_version}
- Build from commit: %{_commit_hash}
- Commit Index: %{_commit_number}
