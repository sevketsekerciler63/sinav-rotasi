# Release checklist

The project has not been published. Keep `pubspec.yaml` at `1.0.0+1` until a
release is actually prepared; every distributed release must have a new build
number. Android `versionCode` and `versionName` come from this value.

## Android signing

1. Create an upload keystore with `keytool` and store it outside the repository.
   Keep at least one encrypted offline backup of the keystore.
2. Copy `android/key.properties.example` to `android/key.properties`, then fill
   in the passwords, alias, and keystore path. Both files containing secrets or
   private keys are excluded from Git.
3. Build the Play Store bundle with `flutter build appbundle --release --no-pub`.
   Create an APK with `flutter build apk --release --no-pub` only when needed for
   direct installation. Without a private signing key the release build stops.
4. Verify the artifact signature and record its SHA-256, version, Git commit,
   and certificate fingerprint in the release record. Never record passwords.
5. Before distribution, install over the previous release and verify local
   profiles, backup export/import, and notification settings. The application
   ID and signing identity must remain stable for an in-place update.

For a local-only release build signed with the Android debug key, explicitly set
`ALLOW_DEBUG_SIGNING_FOR_RELEASE=true` in the build process. Such an artifact is
for development only and must never be published or used as an update to a
production-signed installation.

## iOS and rollback

- Build and sign iOS on macOS with the intended Apple team and distribution
  profile. Record Xcode/build settings and test an update on a device.
- Create an annotated Git tag only after the release artifact and device
  acceptance are complete. Preserve the previous installable artifact and its
  matching source commit so a rollback can be identified.
- Keep `build/`, keystores, provisioning profiles, and passwords out of Git.
- For every release, complete `flutter analyze --no-pub`, Android/iOS release
  builds, device update/restore checks, and the offline/browser acceptance in
  the roadmap. Build success alone does not satisfy device acceptance.
