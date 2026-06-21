# Orbit Note Windows Development

This project is currently developed from Windows, with macOS and Xcode validation delegated to GitHub Actions.

## What Windows Can Safely Do

- Edit Swift, SwiftUI, documentation, and GitHub Actions workflow files.
- Review project structure and Xcode project references statically.
- Run Git and GitHub CLI workflows.
- Run shell syntax checks such as `bash -n scripts/ci/ios_runtime_smoke.sh` when Bash is available.
- Update documentation, CI scripts, and release notes.

Windows cannot locally verify:

- Xcode build output.
- iOS Simulator launch.
- SwiftUI preview rendering.
- Widget Gallery behavior.
- Notification permission prompts or delivery.
- App Group signing behavior.
- Real-device behavior.

## CI Validation Model

GitHub Actions is the current macOS/Xcode verification layer.

The `iOS Build` workflow checks:

- macOS runner and Xcode diagnostics.
- Xcode project and scheme listing.
- CI shell script syntax.
- iOS runtime availability.
- Available iPhone Simulator availability.
- Main app build for iOS Simulator.
- `OrbitNoteWidget` target build with the iOS Simulator SDK.
- Xcode build log artifact upload.

CI does not replace manual Mac, Simulator, or real-device validation.

## Manual Validation Status

Do not mark these as passed from Windows:

- Simulator launch.
- First-launch seed behavior.
- Add / edit / delete / clear / restore flows.
- Restart-after-save SwiftData persistence.
- Notification permission and delivery.
- Widget Gallery insertion.
- Small and medium Widget visual QA.
- App Group real-device signing.
- Widget tap deep link routing.
- iPhone SE layout.

Record manual validation results only after running them on a Mac, iOS Simulator, or real iPhone.

## GitHub HTTPS Recovery

If GitHub HTTPS push or pull times out from Windows:

1. Confirm the local state first:
   - `git status`
   - `git branch --show-current`
   - `git log --oneline --decorate -5`
2. If local work exists, create a bundle backup before retrying network writes:
   - `git bundle create ../orbit-note-backup.bundle master..HEAD`
   - `git bundle verify ../orbit-note-backup.bundle`
3. Test common local proxy ports without writing global Git config:
   - `curl -I --connect-timeout 8 --proxy http://127.0.0.1:7890 https://github.com`
   - `curl -I --connect-timeout 8 --proxy http://127.0.0.1:7897 https://github.com`
   - `curl -I --connect-timeout 8 --proxy http://127.0.0.1:1080 https://github.com`
   - `curl -I --connect-timeout 8 --proxy socks5h://127.0.0.1:10808 https://github.com`
   - `curl -I --connect-timeout 8 --proxy socks5h://127.0.0.1:10809 https://github.com`
4. Use a temporary Git proxy for the one command that needs it.

Example that has worked in this environment:

```powershell
git -c http.proxy=socks5h://127.0.0.1:10808 -c https.proxy=socks5h://127.0.0.1:10808 push
```

Avoid writing global or system proxy settings unless the user explicitly confirms that the proxy should become permanent.

## Release Discipline

- Keep PRs small.
- Keep manual validation status explicit.
- Do not expand SwiftData schema from Windows-only validation.
- Do not change Xcode project settings or entitlements unless that is the scoped task.
- Do not treat CI success as Widget Gallery, notification delivery, or real-device proof.
