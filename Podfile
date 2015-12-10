# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

def testing_pods
    pod 'Quick'
    pod 'Nimble'
end

def ui_pods
    pod 'ChameleonFramework/Swift'
    pod 'FontAwesomeIconFactory'
    pod 'DZNEmptyDataSet'
end

def networking_pods
    pod 'Alamofire'
    pod 'Kingfisher'
    pod 'SwiftyJSON'
    pod 'SWXMLHash'
end

target 'Caster' do

    networking_pods
    ui_pods
    pod 'netfox'
end
