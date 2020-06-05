Pod::Spec.new do |s|
    
    s.name         = "XQGuideView"      #SDK名称
    s.version      = "0.0.1"#版本号
    s.homepage     = "https://github.com/SyKingW/XQGuideView"  #工程主页地址
    s.summary      = "引导页面."  #项目的简单描述
    s.license     = "MIT"  #协议类型
    s.author       = { "Sinking" => "1034439685@qq.com" } #作者及联系方式
    
    s.osx.deployment_target  = '10.13'
    s.ios.deployment_target  = "9.3" #平台及版本
    
    s.source       = { :git => "https://github.com/SyKingW/XQGuideView.git", :tag => "#{s.version}"}   #工程地址及版本号
    
    s.requires_arc = true   #是否必须arc
    
    s.source_files = 'SDK/**/*.{h,m}'
    s.resources = 'SDK/**/*.{xcassets}'
    #s.prefix_header_file = 'XQCompanyTool/XQCompanyToolPrefixHeader.pch'
    
    #依赖的第三方库
    s.dependency "Masonry"
    
    #项目配置
    #s.pod_target_xcconfig = {
    #    'SKIP_INSTALL' => 'YES'
    #    }
    
end

