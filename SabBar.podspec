#  Be sure to run `pod spec lint SabBar.podspec'

Pod::Spec.new do |s|
  s.name         = "SabBar"
  s.version      = "0.1.0"
  s.summary      = "Drop-in UITabBarController subclass that support lateral tabs based on size classes."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
    Drop-in `UITabBarController` subclass that support lateral tabs based on size classes.
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
