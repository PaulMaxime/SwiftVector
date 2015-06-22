Pod::Spec.new do |s|
  s.name         = "SwiftVector"
  s.version      = "0.0.3"
  s.summary      = "A vector library in Swift. This is my vector lib. There are many like it but this one is mine."

  s.description  = <<-DESC
                   A longer description of SwiftVector in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/PaulMaxime/SwiftVector"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Paul Franceus" => "pfranceus@gmail.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source = { :git => "https://github.com/PaulMaxime/SwiftVector.git", :tag => s.version }
  s.source_files  = "SwiftVector/**/*.{h,swift}"
  s.exclude_files = "SwiftVector/SwiftVectorTests/*.swift"
  s.public_header_files = "SwiftVector/SwiftVector/*.h"
  s.requires_arc = true
end
