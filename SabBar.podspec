#  Be sure to run `pod spec lint SabBar.podspec'

Pod::Spec.new do |s|
  s.name         = "SabBar"
  s.version      = "0.9.0"
  s.summary      = "Drop-in UITabBarController subclass that shows a sidebar with tabs based on trait collections."

  s.description  = <<-DESC
  `SabBarController` is a subclass of `UITabBarController` that adds the option
  to show a sidebar with tabs instead of the classic `UITabBar` based on trait
  collections.

  ![iPhone-landscape](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/iPhone-landscape.png)

  In order to use it, just instantiate it instead of the standard
  `UITabBarController` programmatically or within Storyboards.

  ![custom-class](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/custom-class.jpg)
                   DESC

  s.homepage           = "https://github.com/macteo/SabBar"
  s.license            = "MIT"
  s.author             = { "Matteo Gavagnin" => "m@macteo.it" }
  s.social_media_url   = "https://twitter.com/@macteo"
  s.platform           = :ios, "8.0"
  s.source             = { :git => "https://github.com/macteo/SabBar.git", :tag => "v#{s.version}" }
  s.source_files       = "Sources/**/*.{swift}"
  s.requires_arc       = true
end
