{combine_script id='jquery.colorbox' load='footer' require='jquery' path='themes/default/js/plugins/jquery.colorbox.min.js'}
{combine_css path="themes/default/js/plugins/colorbox/style2/colorbox.css"}

{combine_script id='jquery.selectize' load='header' path='themes/default/js/plugins/selectize.min.js'}
{combine_css id='jquery.selectize' path="themes/default/js/plugins/selectize.{$themeconf.colorscheme}.css"}

{combine_script id='jquery.ui.slider' require='jquery.ui' load='header' path='themes/default/js/ui/minified/jquery.ui.slider.min.js'}
{combine_css path="themes/default/js/ui/theme/jquery.ui.slider.css"}

{literal}
<style>
.rowSelected {background-color:#C2F5C2 !important}
.comment p {text-align:left; margin:5px 0 0 5px}
.comment table {margin:5px 0 0 0}
.comment table th {padding-right:10px}

.button {
  border: none; 
  border-radius: 0.3em;
  padding: 0.2em 1em;
  font-weight: 600;
  cursor: pointer;
}

.button-orange {background-color: #FFA646;}
.button-gray {background-color: #CCC; color: #555;}

.link {
  color: #fff;
  position: absolute;
  top: 0;
  left: 0;
  background-color: #000;
  padding: 0.6em;
}
</style>
{/literal}

{literal}
<script type="text/javascript">
jQuery(document).ready(function(){
  /* Startup */
  selectionMode(false);

  jQuery("a.zoom").colorbox({rel:"zoom"});

  function checkSelectedRows() {
    $(".checkPhoto").each(function() {
      var row = $(this).parent("tr");
      var checkbox = $(this).children("input[type=checkbox]");

      if ($(checkbox).is(':checked')) {
        $(row).addClass("rowSelected"); 
      }
      else {
        $(row).removeClass("rowSelected"); 
      }
    });
  }

  $(".checkPhoto").click(function(event) {
    if (event.target.type !== 'checkbox') {
      var checkbox = $(this).children("input[type=checkbox]");
      jQuery(checkbox).prop('checked', !jQuery(checkbox).prop('checked'));
    }
    checkSelectedRows();
  });

  $("#selectAll").click(function () {
    $(".checkPhoto input[type=checkbox]").prop('checked', true);
    checkSelectedRows();
    return false;
  });

  $("#selectNone").click(function () {
    $(".checkPhoto input[type=checkbox]").prop('checked', false);
    checkSelectedRows();
    return false;
  });

  $("#selectInvert").click(function () {
    $(".checkPhoto input[type=checkbox]").each(function() {
      jQuery(this).prop('checked', !jQuery(this).prop('checked'));
    });
    checkSelectedRows();
    return false;
  });

});
</script>
{/literal}

{combine_script id='user_list' load='footer' path='admin/themes/default/js/user_list.js'}

{if !empty($photos) }

<div class="selection-mode-group-manager" style="right:30px">
  <label class="switch">
    <input type="checkbox" id="toggleSelectionMode">
    <span class="slider round"></span>
  </label>
  <p>{'Selection mode'|@translate}</p>
</div>

<form method="post" action="">
  <fieldset>
    <p class="not-in-selection-mode icon-help-circled">{'Validez ou rejetez les photos en attente'|@translate}</p>

    <div class="in-selection-mode">
      <div id="checkActions">
        <span>{'Select'|@translate}</span>
        <a href="#" id="selectAllPage">{'The whole page'|@translate}</a>
        <a href="#" id="selectSet">{'The whole set'|@translate}</a><span class="loading" style="display:none"><img src="themes/default/images/ajax-loader-small.gif"></span>
        <a href="#" id="selectNone">{'None'|@translate}</a>
        <a href="#" id="selectInvert">{'Invert'|@translate}</a>
        <span id="selectedMessage"></span>
      </div>
    </div>
  </fieldset>

  <fieldset>
    <div style="width:75%;display:grid;grid-template-columns:repeat(3,1fr);grid-gap:20px;">
      {foreach from=$photos item=photo name=photo}
      <div style="box-shadow:0px 1px 5px rgba(0,0,0,0.3);">
        <div style="display:flex;justify-content:center;background:#333;position:relative;">
          <a href="{$photo.U_EDIT}" class="externalLink link"><i class="icon-pencil"></i></a>
          <img src="{$photo.TN_SRC}" style="margin:1em">
        </div>

        <div style="padding-bottom:1em;">
          <strong><p>{'User'|@translate}: <span style="color:#000;">{$photo.ADDED_BY}</span></p></strong>
          <strong><p>{'Album'|@translate}: <span style="color:#000;">{$photo.ALBUM}</span></p></strong>
          <strong><p>{'Name'|@translate}: <span style="color:#000;">{$photo.NAME} {$photo.FILE}</span></p></strong>
          <strong><p>{'Créée le'|@translate}: <span style="color:#000;">{$photo.ADDED_ON}</span></p></strong>
          <strong class="not-in-selection-mode"><p>{'Permission'|@translate}: <span style="color:#000;">{$photo}</span> <i class="icon-help-circled"></i></p></strong>

          <div style="margin:1em 1em 0;">
            <button class="button button-orange"><i class="icon-ok"></i> Valider</button>
            <button class="button button-gray"><i class="icon-trash-1"></i> Rejeter</button>
          </div>
        </div>
      </div>
      {/foreach}
    </div>
  </fieldset>
</form>
{/if}
