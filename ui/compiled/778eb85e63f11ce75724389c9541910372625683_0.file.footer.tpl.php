<?php
/* Smarty version 4.5.3, created on 2026-04-18 15:53:52
  from 'C:\Users\Administrator\Downloads\testing billing\ui\ui\admin\footer.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '4.5.3',
  'unifunc' => 'content_69e37ee0e35650_22035548',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '778eb85e63f11ce75724389c9541910372625683' => 
    array (
      0 => 'C:\\Users\\Administrator\\Downloads\\testing billing\\ui\\ui\\admin\\footer.tpl',
      1 => 1776361565,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_69e37ee0e35650_22035548 (Smarty_Internal_Template $_smarty_tpl) {
?></section>
</div>
<footer class="main-footer">
</footer>
</div>
<?php echo '<script'; ?>
 src="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/scripts/jquery.min.js"><?php echo '</script'; ?>
>
<?php echo '<script'; ?>
 src="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/scripts/bootstrap.min.js"><?php echo '</script'; ?>
>
<?php echo '<script'; ?>
 src="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/scripts/adminlte.min.js"><?php echo '</script'; ?>
>
<?php echo '<script'; ?>
 src="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/scripts/plugins/select2.min.js"><?php echo '</script'; ?>
>
<?php echo '<script'; ?>
 src="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/scripts/pace.min.js"><?php echo '</script'; ?>
>
<?php echo '<script'; ?>
 src="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/summernote/summernote.min.js"><?php echo '</script'; ?>
>
<?php echo '<script'; ?>
 src="<?php echo $_smarty_tpl->tpl_vars['app_url']->value;?>
/ui/ui/scripts/custom.js?2025.2.5"><?php echo '</script'; ?>
>

<?php echo '<script'; ?>
>
    document.getElementById('openSearch').addEventListener('click', function () {
        document.getElementById('searchOverlay').style.display = 'flex';
    });

    document.getElementById('closeSearch').addEventListener('click', function () {
        document.getElementById('searchOverlay').style.display = 'none';
    });

    document.getElementById('searchTerm').addEventListener('keyup', function () {
        let query = this.value;
        $.ajax({
            url: '<?php echo Text::url('search_user');?>
',
            type: 'GET',
            data: { query: query },
            success: function (data) {
                if (data.trim() !== '') {
                    $('#searchResults').html(data).show();
                } else {
                    $('#searchResults').html('').hide();
                }
            }
        });
    });
<?php echo '</script'; ?>
>

<?php echo '<script'; ?>
>
    const toggleIcon = document.getElementById('toggleIcon');
    const body = document.body;
    const savedMode = localStorage.getItem('mode');
    if (savedMode === 'dark') {
        body.classList.add('dark-mode');
        toggleIcon.textContent = '🌞';
    }

    function setMode(mode) {
        if (mode === 'dark') {
            body.classList.add('dark-mode');
            toggleIcon.textContent = '🌞';
        } else {
            body.classList.remove('dark-mode');
            toggleIcon.textContent = '🌜';
        }
    }

    toggleIcon.addEventListener('click', () => {
        if (body.classList.contains('dark-mode')) {
            setMode('light');
            localStorage.setItem('mode', 'light');
        } else {
            setMode('dark');
            localStorage.setItem('mode', 'dark');
        }
    });
<?php echo '</script'; ?>
>

<?php if ((isset($_smarty_tpl->tpl_vars['xfooter']->value))) {?>
    <?php echo $_smarty_tpl->tpl_vars['xfooter']->value;?>

<?php }?>

    <?php echo '<script'; ?>
>
        var listAttApi;
        var posAttApi = 0;
        $(document).ready(function() {
            $('.select2').select2({theme: "bootstrap"});
            $('.select2tag').select2({theme: "bootstrap", tags: true});
            var listAtts = document.querySelectorAll(`button[type="submit"]`);
            listAtts.forEach(function(el) {
                if (el.addEventListener) { // all browsers except IE before version 9
                    el.addEventListener("click", function() {
                        var txt = $(this).html();
                        $(this).html(
                            `<span class="loading"></span>`
                        );
                        setTimeout(() => {
                            $(this).prop("disabled", true);
                        }, 100);
                        setTimeout(() => {
                            $(this).html(txt);
                            $(this).prop("disabled", false);
                        }, 5000);
                    }, false);
                } else {
                    if (el.attachEvent) { // IE before version 9
                        el.attachEvent("click", function() {
                            var txt = $(this).html();
                            $(this).html(
                                `<span class="loading"></span>`
                            );
                            setTimeout(() => {
                                $(this).prop("disabled", true);
                            }, 100);
                            setTimeout(() => {
                                $(this).html(txt);
                                $(this).prop("disabled", false);
                            }, 5000);
                        });
                    }
                }

            });
            setTimeout(() => {
                listAttApi = document.querySelectorAll(`[api-get-text]`);
                apiGetText();
            }, 500);
        });

        function ask(field, text){
            var txt = field.innerHTML;
            if (confirm(text)) {
                setTimeout(() => {
                    field.innerHTML = field.innerHTML.replace(`<span class="loading"></span>`, txt);
                    field.removeAttribute("disabled");
                }, 5000);
                return true;
            } else {
                setTimeout(() => {
                    field.innerHTML = field.innerHTML.replace(`<span class="loading"></span>`, txt);
                    field.removeAttribute("disabled");
                }, 500);
                return false;
            }
        }

        function apiGetText(){
            var el = listAttApi[posAttApi];
            if(el != undefined){
                $.get(el.getAttribute('api-get-text'), function(data) {
                    el.innerHTML = data;
                    posAttApi++;
                    if(posAttApi < listAttApi.length){
                        apiGetText();
                    }
                });
            }
        }

        function setKolaps() {
            var kolaps = getCookie('kolaps');
            if (kolaps) {
                setCookie('kolaps', false, 30);
            } else {
                setCookie('kolaps', true, 30);
            }
            return true;
        }

        function setCookie(name, value, days) {
            var expires = "";
            if (days) {
                var date = new Date();
                date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
                expires = "; expires=" + date.toUTCString();
            }
            document.cookie = name + "=" + (value || "") + expires + "; path=/";
        }

        function getCookie(name) {
            var nameEQ = name + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') c = c.substring(1, c.length);
                if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
            }
            return null;
        }

        $(function() {
            $('[data-toggle="tooltip"]').tooltip()
        })
        $("[data-toggle=popover]").popover();
    <?php echo '</script'; ?>
>


</body>

</html><?php }
}
