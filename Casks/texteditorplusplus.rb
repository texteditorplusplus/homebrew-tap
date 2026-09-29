cask "texteditorplusplus" do
  version "26.21"
  sha256 "0fe4a2f26e812f1c5da9f7a4c892c95772344fee7a0b1adcd833007b82ddf17e"

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

  # TextEditor++ is often installed from the DMG first. Instead of failing on the existing copy,
  # upgrade an older one, take over an identical one, and never replace a newer one.
  # Nothing asks the customer anything: an open older copy is quit (session recovery keeps its
  # tabs and unsaved work) and TextEditor++ opens when the install finishes.
  preflight do
    existing = appdir/"TextEditor++.app"
    next if !existing.exist? || existing.symlink?

    installed = system_command("/usr/libexec/PlistBuddy",
                               args:         ["-c", "Print :CFBundleShortVersionString",
                                              existing/"Contents/Info.plist"],
                               must_succeed: false).stdout.strip
    next if installed.empty?

    if Gem::Version.new(installed) > Gem::Version.new(version.to_s)
      raise CaskError, "TextEditor++ #{installed} is installed, which is newer than #{version}. Nothing to do."
    end

    if Gem::Version.new(installed) == Gem::Version.new(version.to_s)
      ohai "You are on the latest version of TextEditor++ (#{version}). Homebrew will keep it up to date from now on."
    else
      ohai "Upgrading TextEditor++ #{installed} to #{version}"
      executable = (existing/"Contents/MacOS/").to_s
      running = -> { system_command("/bin/ps", args: ["-axww", "-o", "command="], must_succeed: false).stdout.include?(executable) }
      if running.call
        system_command "/usr/bin/osascript",
                       args:         ["-e", "tell application \"#{existing}\" to quit"],
                       must_succeed: false
        40.times do
          break unless running.call

          sleep 0.5
        end
        raise CaskError, "TextEditor++ #{installed} did not quit. Quit it, then run the command again." if running.call
      end
    end
    FileUtils.rm_r existing
  end

  postflight do
    next if ENV["HOMEBREW_TEXTEDITORPLUSPLUS_NO_LAUNCH"]

    system_command "/usr/bin/open", args: [appdir/"TextEditor++.app"], must_succeed: false
  end

  zap trash: [
    "~/Library/Application Support/texteditorplusplus",
    "~/Library/Caches/com.texteditorplusplus.editor",
    "~/Library/Caches/texteditorplusplus",
    "~/Library/HTTPStorages/com.texteditorplusplus.editor",
    "~/Library/Preferences/com.texteditorplusplus.editor.plist",
    "~/Library/Saved Application State/com.texteditorplusplus.editor.savedState",
  ]
end
