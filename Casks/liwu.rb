cask "liwu" do
  version "1.0.4"
  sha256 "b4271937ed7dd8a06a96a35e1d1becd9738dd653a5452cf9efc1a4bb1bec891c"

  url "https://github.com/urfreespace/liwu-releases/releases/download/v#{version}/Liwu-#{version}.dmg",
      verified: "github.com/urfreespace/liwu-releases/"
  name "Liwu"
  desc "Menu bar battery charge limiter"
  homepage "https://liwu.app/"

  livecheck do
    url "https://liwu.app/appcast.xml"
    # Use shortVersionString only: the default sparkle strategy appends the build
    # number (for example, 1.0.4,162), which doesn't match the plain version in the DMG filename.
    strategy :sparkle, &:short_version
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Liwu.app"

  # zap is intentionally omitted: helper/config on-disk locations are not guessed;
  # to be added once confirmed with the developer.
end
