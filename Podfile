platform :ios, '8.0'

source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

target 'ZTMusic' do
     # ------------------ 个人开源Pod仓库 ------------------
     # TLKit 基础库，包含常用宏定义、常用分类、常用功能组件（HUD、actionSheet等）
     pod 'TLKit', :git => 'https://github.com/tbl00c/TLKit.git', :tag => '0.0.27'

     # ------------------ 第三方Pod仓库 ------------------
     pod 'AFNetworking', '~> 3.1.0'
     pod 'SDWebImage', '~> 4.3.1'
     pod 'Masonry', '~> 1.1.0'
     pod 'MJRefresh', '~> 3.1.15.3'
     pod 'MJExtension', '~> 3.0.15'
     pod 'IQKeyboardManager', '~> 6.1.1'
     pod 'WCDB', '~> 1.0.6'
     pod 'OpenUDID', '~> 1.0.0'
     pod 'UICKeyChainStore', '~> 2.1.1'
     pod 'YYText', '~> 1.0.7'
     pod 'YYCache', '~> 1.0.4'
     pod 'DKNightVersion', '~> 2.4.3'

     #pod 'UMCCommon', '~> 1.4.1'
     #pod 'UMCSecurityPlugins'
     #pod 'UMCAnalytics'
     pod 'JPush', '~> 3.0.9'
     pod 'KTVHTTPCache', '~> 2.0.0'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['CC'] = '$SRCROOT/../CCache/ccache-clang'
        config.build_settings['CLANG_ENABLE_MODULES'] = 'NO'
    end
end
