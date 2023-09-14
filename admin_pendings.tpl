{combine_script id='jquery.colorbox' load='footer' require='jquery' path='themes/default/js/plugins/jquery.colorbox.min.js'}
{combine_css path="themes/default/js/plugins/colorbox/style2/colorbox.css"}

{combine_script id='jquery.selectize' load='header' path='themes/default/js/plugins/selectize.min.js'}
{combine_css id='jquery.selectize' path="themes/default/js/plugins/selectize.{$themeconf.colorscheme}.css"}

{combine_script id='jquery.ui.slider' require='jquery.ui' load='header' path='themes/default/js/ui/minified/jquery.ui.slider.min.js'}
{combine_css path="themes/default/js/ui/theme/jquery.ui.slider.css"}

{literal}
<style>
.comment p {text-align:left; margin:5px 0 0 5px}
.comment table {margin:5px 0 0 0}
.comment table th {padding-right:10px}

.descritpion {
  min-height: 15em;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  gap: 1em;
  padding: 1em 1.5em;
}

.descritpion p {
  color: #777;
  margin-block-start: 0;
  margin-block-end: 0;
  margin: 0;
}

.descritpion span {
  color: #000;
}

.btn {
  border: none; 
  padding: 0.2em 1em;
  font-weight: 600;
  cursor: pointer;
}

.btn.orange {background-color: #FFA646;}
.btn.gray {background-color: #CCC; color: #555;}
.btn.rounded {border-radius: 0.3em;}
.gray {background-color: #CCC !important; color: #555 !important;}
.gray:hover {background-color: #AAA !important;}

.link {
  color: #fff;
  position: absolute;
  top: 0;
  left: 0;
  background-color: #000;
  padding: 0.6em;
}

.checkPhoto {
  width: 3em;
  height: 3em;
  position: absolute;
  display: flex;
  top: 1em;
  right: 1em;
  border-radius: 100%;
  border: 2px solid #FFA646;
}

.checkPhoto:hover {
  background-color: #FFA646;
}

.checkPhoto.rowSelected {
  background-color: #FFA646;
  justify-content: center;
  align-items: center;
}

.checkPhoto .selectIcon {
  display: none;
}

.checkPhoto.rowSelected .selectIcon {
  display: block;
  color: #FFF;
  font-size: large;
}
</style>
{/literal}

{literal}
<script type="text/javascript">
let selection = [];

$(document).ready(function(){
  selectionMode(false);

  function isSelectionMode() {
    return $("#toggleSelectionMode").is(":checked")
  }

  function selectionMode(isSelection) {
    if (isSelection) {
      $(".in-selection-mode").show();
      $(".not-in-selection-mode").hide();
    } else {
      $(".in-selection-mode").hide();
      $(".not-in-selection-mode").show();
    }
  }

  $("#toggleSelectionMode").attr("checked", false);
  $("#toggleSelectionMode").click(function () {
    selectionMode($(this).is(":checked"));
  });

  $("a.zoom").colorbox({rel:"zoom"});

  function checkSelectedRows() {
    $(".checkPhoto").each(function() {
      const checkbox = $(this).children("input[type=checkbox]");
      const value = checkbox[0].value;

      if ($(checkbox).is(':checked')) {
        $(this).addClass("rowSelected");
        if (selection.includes(value)) return;
        selection.push(value);
      }
      else {
        $(this).removeClass("rowSelected");
        if (!selection.includes(value)) return;
        selection = selection.filter((i) => i !== value);
      }
    });
  }

  $(".checkPhoto").click(function(event) {
    checkSelectedRows();
  });

  $("#selectAllPage").click(function () {
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
      $(this).prop('checked', !$(this).prop('checked'));
    });
    checkSelectedRows();
    return false;
  });

  $(".validatePhoto").click(function () {
    let $form = $("#formPhotos");
    const value = $(this)[0].value;

    let serializedData = $form.serialize();
    serializedData = serializedData.concat(`&photos%5B%5D=${value}&validate="Valider"`);

    $.ajax({
      type: "POST",
      url: "",
      data: serializedData,
    });
  });

  $(".rejectPhoto").click(function () {
    let $form = $("#formPhotos");
    const value = $(this)[0].value;

    let serializedData = $form.serialize();
    serializedData = serializedData.concat(`&photos%5B%5D=${value}&reject="Rejeter"`);

    $.ajax({
      type: "POST",
      url: "",
      data: serializedData,
    });
  });
});
</script>
{/literal}

{if !empty($photos) }

<form id="formPhotos" method="post" action="">
  <div class="selection-mode-group-manager" style="width:13%;right:30px;">
    <div style="display:flex;justify-content:right;align-items:center;">
      <label class="switch">
        <input type="checkbox" id="toggleSelectionMode">
        <span class="slider round"></span>
      </label>
      <p>{'Selection mode'|@translate}</p>
    </div>

    <div class="in-selection-mode">
      <legend>{'Who can see these photos?'|@translate}</legend>

      <select name="level" size="1">
        {html_options options=$level_options selected=$level_options_selected}
      </select>

      <div style="display:flex;flex-direction:column;gap:0.5em;margin-top:1em;">
        <input class="submit" type="submit" name="validate" value="{'Validate'|@translate}">
        <input class="submit gray" type="submit" name="reject" value="{'Reject'|@translate}">
      </div>
    </div>
  </div>

  <fieldset style="height:2em;display:flex;align-items:center;">
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
    <div style="width:82%;display:grid;grid-template-columns:repeat(3,1fr);gap:20px;">
      {foreach from=$photos item=photo name=photo}
      <div style="box-shadow:0px 1px 5px rgba(0,0,0,0.3);">
        <div style="height:14em;display:flex;justify-content:center;align-items:center;background:#333;position:relative;">
          <a href="{$photo.U_EDIT}" class="externalLink link"><i class="icon-pencil"></i></a>
          <img src="{$photo.TN_SRC}" style="margin:1em">
          
          <label class="in-selection-mode checkPhoto">
            <input id="photos" type="checkbox" name="photos[]" value="{$photo.ID}" style="z-index:99;display:none;">
            <i class="selectIcon icon-ok"></i>
          </label>
        </div>

        <div class="descritpion">
          <strong><p>{'User'|@translate}: <span style="color:#000;">{$photo.ADDED_BY}</span></p></strong>
          <strong><p>{'Album'|@translate}: <span style="color:#000;">{$photo.ALBUM}</span></p></strong>
          <strong><p>{'Name'|@translate}: <span style="color:#000;margin:0;">{$photo.NAME} {$photo.FILE}</span></p></strong>
          <strong><p>{'Créée le'|@translate}: <span style="color:#000;margin:0;">{$photo.ADDED_ON}</span></p></strong>
          <strong><p>{'Permission'|@translate}: <span style="color:#000;margin:0;">{$photo}</span> <i class="icon-help-circled"></i></p></strong>

          <div class="not-in-selection-mode">
            <button value="{$photo.ID}" type="button" class="validatePhoto btn orange rounded"><i class="icon-ok"></i> Valider</button>
            <button value="{$photo.ID}" type="button" class="rejectPhoto btn gray rounded"><i class="icon-trash-1"></i> Rejeter</button>
          </div>
        </div>
      </div>
      {/foreach}
    </div>
  </fieldset>
</form>
{/if}
