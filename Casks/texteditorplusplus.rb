cask "texteditorplusplus" do
  version "26.20"
  sha256 "817d085b7f9ac9f88c2cc0d024c76150a4f7cb14a969a65b12374ef9a8d0dfdb"

  url "https://downloads.texteditorplusplus.com/releases/TextEditorPlusPlus-#{version}-arm64.dmg"
  name "TextEditor++"
  desc "Text editor for large files, live server logs and text extraction"
  homepage "https://texteditorplusplus.com/"

  livecheck do
    url "https://downloads.texteditorplusplus.com/updates/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "TextEditor++.app"

  zap trash: [
    "~/Library/Application Support/texteditorplusplus",
    "~/Library/Caches/com.texteditorplusplus.editor",
    "~/Library/Caches/texteditorplusplus",
    "~/Library/HTTPStorages/com.texteditorplusplus.editor",
    "~/Library/Preferences/com.texteditorplusplus.editor.plist",
    "~/Library/Saved Application State/com.texteditorplusplus.editor.savedState",
  ]
end
