add-type -assembly System.Windows.Forms
add-type -AssemblyName System.Drawing

$Form = new-object System.Windows.Forms.Form
$Form.text = "FaceRig Live2D モデル追加ツール"
$Form.size = "512, 300"

$Label1 = new-object System.Windows.Forms.Label
$Label1.text = "名前"
$Label1.font = "BIZ UDゴシック, 16"
$Label1.width = 176
$Label1.location = new-object System.Drawing.Point(16, 16)
$Form.controls.add($Label1)

$TextBox1 = new-object System.Windows.Forms.TextBox
$TextBox1.location = new-object System.Drawing.Point(192, 16)
$TextBox1.font = "BIZ UDゴシック, 12"
$TextBox1.width = 192
$Form.controls.add($TextBox1)

###############################################
$Label2 = new-object System.Windows.Forms.Label
$Label2.text = "MOC"
$Label2.font = "BIZ UDゴシック, 16"
$Label2.width = 176
$Label2.location = new-object System.Drawing.Point(16, 64)
$Form.controls.add($Label2)

$TextBox2 = new-object System.Windows.Forms.TextBox
$TextBox2.location = new-object System.Drawing.Point(192, 64)
$TextBox2.font = "BIZ UDゴシック, 12"
$TextBox2.width = 192
$Form.controls.add($TextBox2)

$Button2 = new-object System.Windows.Forms.Button
$Button2.text = "開く"
$Button2.location = new-object System.Drawing.Point(400, 64)
$Button2.font = "BIZ UDゴシック, 16"
$button2.height = 32
$Form.controls.add($Button2)
$button2.add_click({
    $dialog = new-object System.Windows.Forms.OpenFileDialog
    $dialog.filter = "(*.moc)|*.moc"
    $dialog.title = "moc ファイルを選択してください"
    $dialog.ShowDialog()
    $TextBox2.text = $dialog.filename
})


###############################################
$Label3 = new-object System.Windows.Forms.Label
$Label3.text = "テクスチャ画像"
$Label3.font = "BIZ UDゴシック, 16"
$Label3.width = 176
$Label3.location = new-object System.Drawing.Point(16, 112)
$Form.controls.add($Label3)

$TextBox3 = new-object System.Windows.Forms.TextBox
$TextBox3.location = new-object System.Drawing.Point(192, 112)
$TextBox3.font = "BIZ UDゴシック, 12"
$TextBox3.width = 192
$Form.controls.add($TextBox3)

$Button3 = new-object System.Windows.Forms.Button
$Button3.text = "開く"
$Button3.location = new-object System.Drawing.Point(400, 112)
$Button3.font = "BIZ UDゴシック, 16"
$button3.height = 32
$Form.controls.add($Button3)
$button3.add_click({
    $dialog = new-object System.Windows.Forms.OpenFileDialog
    $dialog.filter = "(*.png)|*.png"
    $dialog.title = "テクスチャ画像のファイル(*.png)を選択してください"
    $dialog.ShowDialog()
    $TextBox3.text = $dialog.filename
})

###############################################
$Label4 = new-object System.Windows.Forms.Label
$Label4.text = "サムネイル画像"
$Label4.font = "BIZ UDゴシック, 16"
$Label4.width = 176
$Label4.location = new-object System.Drawing.Point(16, 160)
$Form.controls.add($Label4)

$TextBox4 = new-object System.Windows.Forms.TextBox
$TextBox4.location = new-object System.Drawing.Point(192, 160)
$TextBox4.font = "BIZ UDゴシック, 12"
$TextBox4.width = 192
$Form.controls.add($TextBox4)

$Button4 = new-object System.Windows.Forms.Button
$Button4.text = "開く"
$Button4.location = new-object System.Drawing.Point(400, 160)
$Button4.font = "BIZ UDゴシック, 16"
$button4.height = 32
$Form.controls.add($Button4)

$button4.add_click({
    $dialog = new-object System.Windows.Forms.OpenFileDialog
    $dialog.filter = "(*.png)|*.png"
    $dialog.title = "サムネイル画像のファイル(*.png)を選択してください"
    $dialog.ShowDialog()
    $TextBox4.text = $dialog.filename
})

###############################################
$Button1 = new-object System.Windows.Forms.Button
$Button1.text = "実行"
$Button1.location = new-object System.Drawing.Point(32, 208)
$Button1.font = "BIZ UDゴシック, 16"
$button1.height = 32
$button1.width = 436

$Form.controls.add($Button1)


function resize($Image1, $width, $height){
    # 画像のリサイズ
    $Image2 = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($Image2)
    $graphics.DrawImage($Image1, (New-Object System.Drawing.Rectangle(0, 0, $Image2.Width, $Image2.Height)))
    $graphics.dispose()
    return $Image2
}

function core($name, $moc, $texu, $ico){
    $fr_dir = "C:\Program Files (x86)\Steam\steamapps\common\FaceRig\Mod\VP\PC_Common\Objects"
    New-Item -ItemType Directory -Path "$fr_dir\$name\" -Force
    New-Item -ItemType Directory -Path "$fr_dir\$name\$name.1024\" -Force
    $img_ico = new-object System.Drawing.Bitmap($ico)
    $img_ico_500 = resize $img_ico 500 500
    $img_ico.dispose()
    $img_ico_500.save("tmp.png", [System.Drawing.Imaging.ImageFormat]::Png)
    Move-Item -Path "tmp.png" -Destination "$fr_dir\$name\ico_$name.png" -Force
    $img_ico_500.dispose()
    Copy-Item -Path "$moc" -Destination "$fr_dir\$name"
    Copy-Item -Path "$texu" -Destination "$fr_dir\$name\$name.1024\texture_00.png"
    echo "set_friendly_name ${name}`nset_avatar_skin_description ${name} default txt_desc${name}`n" > $fr_dir\$name\cc_names_$name.cfg
    return $true
}

function run($name, $moc, $texu, $ico){
    if($name -eq ""){
        [System.Windows.Forms.MessageBox]::Show("名前がありません", "エラー", "OK", "Error") 
        return $false
    }
    if($moc -eq ""){
        [System.Windows.Forms.MessageBox]::Show("moc ファイルが指定されていません", "エラー", "OK", "Error") 
        return $false
    }
    if(!(test-path $moc)){
        [System.Windows.Forms.MessageBox]::Show("moc ファイルが存在しません", "エラー", "OK", "Error") 
        return $false
    }
    if($texu -eq ""){
        [System.Windows.Forms.MessageBox]::Show("テクスチャ画像のファイルが指定されていません", "エラー", "OK", "Error") 
        return $false
    }
    if(!(test-path $texu)){
        [System.Windows.Forms.MessageBox]::Show("テクスチャ画像のファイルが存在しません", "エラー", "OK", "Error") 
        return $false
    }
    if($ico -eq ""){
        [System.Windows.Forms.MessageBox]::Show("サムネイル画像のファイルが指定されていません", "エラー", "OK", "Error") 
        return $false
    }
    if(!(test-path $ico)){
        [System.Windows.Forms.MessageBox]::Show("サムネイル画像のファイルが存在しません", "エラー", "OK", "Error") 
        return $false
    }
    core $name $moc $texu $ico
}

$button1.add_click({
    run $TextBox1.text $TextBox2.text $TextBox3.text $TextBox4.text
})

$Form.showdialog()
