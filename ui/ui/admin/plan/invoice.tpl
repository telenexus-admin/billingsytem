{include file="sections/header.tpl"}
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.4/jspdf.min.js"></script>

<style>
    :root {
        --primary: #f97316;
        --primary-dark: #ea580c;
        --primary-light: #fed7aa;
        --primary-soft: #fff7ed;
    }

    .panel-primary {
        border-color: var(--primary);
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.1);
        border-radius: 16px;
        overflow: hidden;
    }
    
    .panel-primary > .panel-heading {
        background: linear-gradient(145deg, var(--primary), var(--primary-dark));
        color: white;
        border-color: var(--primary-dark);
        font-weight: 600;
        padding: 12px 15px;
    }
    
    .panel-body {
        padding: 25px;
        background: white;
    }
    
    .btn-default {
        background: white;
        border: 2px solid #e2e8f0;
        color: #1e293b;
        border-radius: 30px;
        padding: 6px 15px;
        transition: all 0.2s;
    }
    
    .btn-default:hover {
        border-color: var(--primary);
        color: var(--primary);
    }
    
    .btn-success {
        background: linear-gradient(145deg, var(--primary), var(--primary-dark));
        border: none;
        color: white;
        border-radius: 30px;
        padding: 6px 15px;
        transition: all 0.2s;
        box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3);
    }
    
    .btn-success:hover {
        background: linear-gradient(145deg, var(--primary-dark), #c2410c);
        transform: translateY(-2px);
    }
    
    .btn-primary {
        background: linear-gradient(145deg, var(--primary), var(--primary-dark));
        border: none;
        border-radius: 30px;
        padding: 6px 15px;
    }
    
    .btn-primary:hover {
        background: linear-gradient(145deg, var(--primary-dark), #c2410c);
    }
    
    .btn-info {
        background: var(--primary-soft);
        border: 1px solid var(--primary);
        color: var(--primary-dark);
        border-radius: 30px;
        padding: 6px 15px;
    }
    
    .btn-info:hover {
        background: var(--primary-light);
    }
    
    .form-control.form-sm {
        border: 2px solid var(--primary-light);
        border-radius: 12px;
        padding: 10px;
        color: var(--primary-dark);
        font-weight: 500;
        margin-top: 10px;
    }
    
    .form-control.form-sm:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.1);
    }
    
    #content {
        font-family: 'Courier New', monospace;
        font-size: 14px;
        line-height: 1.5;
        color: #1e293b;
    }
    
    hr {
        border-top: 2px solid var(--primary-light);
        margin: 15px 0;
    }
</style>

<div class="row">
    <div class="col-md-6 col-sm-12 col-md-offset-3">
        <div class="panel panel-hovered panel-primary panel-stacked mb30">
            <div class="panel-heading">
                <i class="glyphicon glyphicon-file" style="margin-right: 8px;"></i>
                {$in['invoice']}
            </div>
            <div class="panel-body">
                {if !empty($logo)}
                    <center><img src="{$app_url}/{$logo}?" style="max-height: 80px; margin-bottom: 15px;"></center>
                {/if}
                <form class="form-horizontal" method="post" action="{Text::url('')}plan/print" target="_blank">
                    <pre id="content"
                    style="border: 0px; text-align: center; background-color: transparent; background-image: url('{$app_url}/system/uploads/paid.png'); background-repeat: no-repeat; background-position: center; background-size: contain;"></pre>
                    <textarea class="hidden" id="formcontent" name="content">{$invoice}</textarea>
                    <input type="hidden" name="id" value="{$in['id']}">
                    
                    <div class="text-center" style="margin-top: 20px;">
                        <a href="{Text::url('plan/list')}" class="btn btn-default btn-sm">
                            <i class="ion-reply-all"></i> {Lang::T('Finish')}
                        </a>
                        <a href="javascript:download()" class="btn btn-success btn-sm">
                            <i class="glyphicon glyphicon-download"></i> {Lang::T('Download')}
                        </a>
                        <a href="https://api.whatsapp.com/send/?text={$whatsapp}" target="_blank" class="btn btn-primary btn-sm">
                            <i class="glyphicon glyphicon-share"></i> WhatsApp
                        </a>
                        <a href="{Text::url('')}plan/view/{$in['id']}/send" class="btn btn-info btn-sm">
                            <i class="glyphicon glyphicon-envelope"></i> {Lang::T("Resend")}
                        </a>
                    </div>
                    
                    <hr>
                    
                    <div class="text-center">
                     
                        <button type="submit" class="btn btn-info btn-sm">
                            <i class="glyphicon glyphicon-print"></i> {Lang::T('Print')} Text
                        </button>
                        <a href="nux://print?text={urlencode($invoice)}" class="btn btn-success btn-sm hidden-md hidden-lg">
                            <i class="glyphicon glyphicon-phone"></i> NuxPrint
                        </a>
                       
                    </div>
                    
                    <div class="mt-3">
                        <input type="text" class="form-control form-sm" style="border: 2px solid var(--primary-light); border-radius: 12px; padding: 10px; background-color: white;" readonly onclick="this.select()" value="{$public_url}">
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    const canvas = document.createElement("canvas");
    const ctx = canvas.getContext('2d');
    ctx.font = '16px Courier';
    var text = document.getElementById("formcontent").innerHTML;
    var lines = text.split(/\r\n|\r|\n/).length;
    var meas = ctx.measureText("A");
    let width = Math.round({$_c['printer_cols']} * 9.6);
    var height = Math.round((14 * lines));
    console.log(width, height, lines);
    var paid = new Image();
    paid.src = '{$app_url}/system/uploads/paid.png';
    {if !empty($logo)}
        var img = new Image();
        img.src = '{$app_url}/{$logo}?{time()}';
        var new_width = (width / 4) * 2;
        var new_height = Math.ceil({$hlogo} * (new_width/{$wlogo}));
        height = height + new_height;
    {/if}

    function download() {
        var doc = new jsPDF('p', 'px', [width, height]);
        {if !empty($logo)}
            try {
                doc.addImage(img, 'PNG', (width - new_width) / 2, 10, new_width, new_height);
            } catch (err) {}
        {/if}
        try {
            doc.addImage(paid, 'PNG', (width - 200) / 2, (height - 145) / 2, 200, 145);
        } catch (err) {}
        doc.setFont("Courier");
        doc.setFontSize(16);
        doc.setTextColor(30, 41, 59); // #1e293b
        doc.text($('#formcontent').html(), width / 2, new_height + 30, 'center');
        doc.save('{$in['invoice']}.pdf');
    }

    var s5_taf_parent = window.location;
    document.getElementById('content').innerHTML = document.getElementById('formcontent').innerHTML;
</script>

{include file="sections/footer.tpl"}