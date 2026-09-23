cask "liwu" do
  version "2.1.2"
  sha256 "a210dff0591c86213254db038139fe68ba61eb85523631bd8d89b9fc5105cde0"

  url "https://github.com/urfreespace/liwu-releases/releases/download/v#{version}/Liwu-#{version}.dmg",
      verified: "github.com/urfreespace/liwu-releases/"
  name "Liwu"
  desc "Menu bar utilities with charging targets and Keep Awake"
  homepage "https://liwu.app/"

  livecheck do
    url "https://liwu.app/appcast.xml"
    # Use shortVersionString only: the default sparkle strategy appends the build
    # number (for example, 1.0.4,162), which doesn't match the plain version in the DMG filename.
    strategy :sparkle, &:short_version
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Liwu.app"

  # Named dependencies cover major releases only; enforce the minor boundary before installation.
  preflight_steps do
    run "/bin/sh", args: ["-c", <<~SH]
      version=$(/usr/bin/sw_vers -productVersion)
      major=${version%%.*}
      rest=${version#*.}
      minor=${rest%%.*}
      if [ "${major}" -lt 26 ] || { [ "${major}" -eq 26 ] && [ "${minor}" -lt 7 ]; }; then
        echo "Liwu 2 requires macOS 26.7 or later. Download Liwu 1 at https://liwu.app/legacy." >&2
        exit 1
      fi
    SH
  end

  # zap is intentionally omitted: helper/config on-disk locations are not guessed;
  # to be added once confirmed with the developer.
end
