{combine_script id='jquery.ui.slider' require='jquery.ui' load='footer' path='themes/default/js/ui/minified/jquery.ui.slider.min.js'}
{combine_css path="themes/default/js/ui/theme/jquery.ui.slider.css"}

{combine_script id='common' load='footer' path='admin/themes/default/js/common.js'}

{literal}
<style>
form{text-align :center ; align:center; }
form fieldset p {text-align:left;margin:0 0 1em 0;line-height:20px;}
form fieldset strong {color: #A4A4A4;
  font-weight: bold;
  font-size: 1.1em;
  margin-bottom: 5px;}
form legend{
    font-size: 1.4em ;
    text-align:center ;
}
.form div ::before {
  margin-top: 10px;
  margin-left: 220px;}
  .user-property-selector1 .user-property-select-container::before {margin-left: 240px;}
  .user-property-selector2 .user-property-select-container::before {margin-left: 118px;}
  .user-property-selector3 .user-property-select-container::before {margin-left: 388px;}


form fieldset select {
box-sizing: border-box;
  -webkit-appearance: none;
  border: none;
  width: 100%;
  padding: 10px;
  font-size: 1.1em;
  }

.permissionActions {text-align:center;height:20px}
.permissionActions a:hover {border:none}
.permissionActions img {margin-bottom:-2px}
.rowSelected {background-color:#C2F5C2 !important}
.permissionCase { display:block;border-radius:15px;
  position:absolute;
  left:50%;
  top: 50%;
  transform:translate(-50%, -48%);
  background-color:white;}
.permsissionBlock{  position: fixed;
  z-index: 100;
  left: 0;
  top: 0;
  width: 100%; 
  height: 100%;
  overflow: auto; 
  background-color: rgba(0,0,0,0.7);}
.icon {text-align:center !important; margin-top:30px;}
  .icon span{text-align:center !important;   background-color: #ffe6cf;
  color: #ffa352;}
  .user-property-mid-share{display:flex;flex-direction:row; gap:5px}
  .user-property-one{width:65%}
    .user-property-two{width:35%}
#community_nb_photos, #community_storage {width:400px; display:inline-block; margin-right:10px;}
  select option {
  width: 1px;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;}

  input[type="checkbox"] {
    width: 15px;
    height: 15px;
    background-color: white;
    border-radius: 50%;
    vertical-align: middle;
    border: 2px solid orange;
    appearance: none !important;
    -webkit-appearance: none !important;
    outline: none;
    cursor: pointer;
}

input[type="checkbox"]:checked {
    background-color: orange;
}

  input[type="radio"] {
    width: 15px;
    height: 15px;
    background-color: white;
    border-radius: 50%;
    vertical-align: middle;
    border: 2px solid orange;
    appearance: none !important;
    -webkit-appearance: none !important;
    outline: none;
    cursor: pointer;
}

input[type="radio"]:checked {
    background-color: orange;
}




 
</style>
{/literal}

{footer_script}{literal}

$(document).ready(function() {
  $("select[name=who]").change(function () {
    $("[name^=who_]").hide();
    $("[name=who_"+$(this).prop("value")+"]").show();
    checkWhoOptions();
  });

  function checkWhoOptions() {
    if ('any_visitor' == $("select[name=who] option:selected").val()) {
      $("#userAlbumOption").attr("disabled", true);
      $("#userAlbumInfo").hide();

      if (-1 == $("select[name=category] option:selected").val()) {
        $("select[name=category]").val("0");
        checkWhereOptions();
      }
    }
    else {
      $("#userAlbumOption").attr("disabled", false);
      $("#userAlbumInfo").show();
    }
  }
  checkWhoOptions();

  function checkWhereOptions() {
    var recursive = $("input[name=recursive]");
    var create = $("input[name=create_subcategories]");

    if ($("select[name=category] option:selected").val() == 0) {
      $(recursive).attr("disabled", true);
      $(recursive).attr('checked', true);
    }
    else if ($("select[name=category] option:selected").val() == -1) {
      /* user upload only */
      $(recursive).attr("disabled", true).attr('checked', false);
      $(create).attr("disabled", true).attr('checked', false);
    }
    else {
      $(recursive).removeAttr("disabled");
    }

    if (!$(recursive).is(':checked')) {
      $(create).attr('checked', false);
      $(create).attr("disabled", true);
    }
    else {
      $(create).removeAttr("disabled");
    }
  }

  checkWhereOptions();

  $("select[name=category]").change(function() {
    checkWhereOptions();
  });

  $("input[name=recursive]").change(function() {
    checkWhereOptions();
  });

  $("#displayForm").click(function() {
    $("[name=add_permission]").show();
    $(this).hide();
    return false;
  });

  /* ∞ */
  /**
   * find the key from a value in the startStopValues array
   */
  function getSliderKeyFromValue(value, values) {
    for (var key in values) {
      if (values[key] == value) {
        return key;
      }
    }
    return 0;
  }

  var nbPhotosValues = [5,10,20,50,100,500,1000,5000,-1];

  function getNbPhotosInfoFromIdx(idx) {
    if (idx == nbPhotosValues.length - 1) {
      return "{/literal}{'no limit'|@translate}{literal}";
    }

    return sprintf(
      "{/literal}{'up to %d photos (for each user)'|@translate}{literal}",
      nbPhotosValues[idx]
    );
  }

  /* init nb_photos info span */
  var nbPhotos_init = getSliderKeyFromValue(jQuery('input[name=nb_photos]').val(), nbPhotosValues);

  jQuery("#community_nb_photos_info").html(getNbPhotosInfoFromIdx(nbPhotos_init));

  jQuery("#community_nb_photos").slider({
    range: "min",
    min: 0,
    max: nbPhotosValues.length - 1,
    value: nbPhotos_init,
    slide: function( event, ui ) {
      jQuery("#community_nb_photos_info").html(getNbPhotosInfoFromIdx(ui.value));
    },
    stop: function( event, ui ) {
      jQuery("input[name=nb_photos]").val(nbPhotosValues[ui.value]);
    }
  });
jQuery("#community_nb_photos").css({"background" : "orange" , "height": "2px" });
jQuery("#community_nb_photos .ui-slider-handle").css({
 "background-color": "#ffaf58",
  "border": "none",
  "border-radius": "25px",
  "top": "-105px !important",
  "width": "1.4em",
  "height": "1.4em",
  "top":"-.7em",
});

$('option').each(function () {
  var text = $(this).text();
  if (text.length > 100) {
    text = text.substring(0, 99) + '...';
    $(this).text(text);
  }
});



  var storageValues = [10,50,100,200,500,1000,5000,-1];

  function getStorageInfoFromIdx(idx) {
    if (idx == storageValues.length - 1) {
      return "{/literal}{'no limit'|@translate}{literal}";
    }

    return sprintf(
      "{/literal}{'up to %dMB (for each user)'|@translate}{literal}",
      storageValues[idx]
    );
  }

  /* init storage info span */
  var storage_init = getSliderKeyFromValue(jQuery('input[name=storage]').val(), storageValues);

  jQuery("#community_storage_info").html(getStorageInfoFromIdx(storage_init));

  jQuery("#community_storage").slider({
    range: "min",
    min: 0,
    max: storageValues.length - 1,
    value: storage_init,
    slide: function( event, ui ) {
      jQuery("#community_storage_info").html(getStorageInfoFromIdx(ui.value));
    },
    stop: function( event, ui ) {
      jQuery("input[name=storage]").val(storageValues[ui.value]);
    }
  });

  jQuery("#community_storage .ui-slider-handle").html('').css("border", "none");
jQuery("#community_storage .ui-slider-range").css("height", "2px"); 

jQuery("#community_storage").css({"background" : "orange" , "height": "2px" });
jQuery("#community_storage .ui-slider-handle").css({
  "background-color": "#ffaf58",
  "border-radius": "25px",
  "top": "-105px !important",
  "width": "1.4em",
  "height": "1.4em",
  "top":"-.7em",
});
jQuery("#community_storage .ui-slider-handle").html('').css("border", "none");
jQuery("#community_storage .ui-slider-range").css("height", "2px"); 

});
{/literal}{/footer_script}

{if not isset($edit)}
<a id="displayForm" href="#">{'Add a permission'|@translate}</a>
{/if}
<div class="permsissionBlock" name="add_permission"  {if not isset($edit)}style="display:none"{/if}>
<div class="permissionCase">
<a class="icon-cancel CloseUserList CloseGuestUserList" href="{$F_ADD_ACTION}"></a>
<form method="post" name="add_permission" action="{$F_ADD_ACTION}" class="properties" {if not isset($edit)}style="display:none"{/if}>
      <div class="icon">
<span class="AddIcon icon icon-plus-circled"></span></div>
  <fieldset>
    <legend align=center>{if isset($edit)}{'Edit a permission'|@translate}{else}{'Add a permission'|@translate}{/if}</legend>
    <p>
      <strong >{'Who?'|@translate}</strong>
      <div class="user-property-mid-share">
      <div class="user-property-one"> 
      <div class="user-property-selector1"> 
       <div class="user-property-select-container">
      <select name="who">
{html_options options=$who_options selected=$who_options_selected}
      </select>
      </div>
      </div>
      </div>
            <div class="user-property-two"> 
                  <div class="user-property-selector2"> 
           <div name="who_user" class="user-property-select-container" {if not isset($user_options_selected)}style="display:none"{/if}>
      <select name="who_user" {if not isset($user_options_selected)}style="display:none"{/if}>

{html_options options=$user_options selected=$user_options_selected}
      </select>
      </div>
</div>
      <div class="user-property-selector2"> 
       <div name="who_group" class="user-property-select-container" {if not isset($user_options_selected)}style="display:none"{/if}>
      <select name="who_group" {if not isset($group_options_selected)}style="display:none"{/if}>
{html_options options=$group_options selected=$group_options_selected}
      </select>
      </div>
      </div>
      </div>
          </div>

    </p>

    <p>
      <strong>{'Where?'|@translate}</strong> {if $community_conf.user_albums}<em id="userAlbumInfo">{'(in addition to user album)'|@translate}</em>{/if}
            <div class="user-property-selector3"> 
             <div class="user-property-select-container">
      <select class="categoryDropDown" name="category">
{if $community_conf.user_albums}
        <option value="-1"{if $user_album_selected} selected="selected"{/if} id="userAlbumOption">{'User album only'|@translate}</option>
{/if}
        <option value="0"{if $whole_gallery_selected} selected="selected"{/if}>{'The whole gallery'|@translate}</option>
        <option disabled="disabled">------------</option>
        {html_options options=$category_options selected=$category_options_selected}
      </select>
      </div>
</div>
  
      <br>
      <label>
  <input  type="checkbox"  name="recursive" {if $recursive}checked="checked"{/if}>
  <span>{'Apply to sub-albums'|@translate}</span>
</label>
<br>
<label>
  <input  type="checkbox"  name="create_subcategories" {if $create_subcategories}checked="checked"{/if}>
  <span>{'ability to create sub-albums'|@translate}</span>
</label>

    </p>

    <p>
      <strong>{'Which level of trust?'|@translate}</strong>
      <span class="icon-info-circled-1" style="color:orange;font-size:1.1em" title="{'low trust'|@translate} : {'uploaded photos must be validated by an administrator'|@translate} 
{'high trust'|@translate} : {'uploaded photos are directly displayed in the gallery'|@translate} "></span>
      <br>
      <label><input type="radio" name="moderated" value="true" {if $moderated}checked="checked"{/if}>
       <em>{'low trust'|@translate}</em></label>
      <br>
      <label><input type="radio" name="moderated" value="false" {if not $moderated}checked="checked"{/if}>
       <em>{'high trust'|@translate}</em> </label>
    </p>

    <p style="margin-bottom:0">
      <strong>{'How many photos?'|@translate}</strong>
       <span style="color:orange; font-size:0.8em;" id="community_nb_photos_info">{'no limit'|@translate}</span>
    <input style="color:orange; font-size:0.8em;" type="hidden" name="nb_photos" value="{$nb_photos}">
    </p>
    <div id="community_nb_photos"></div>
   

    <p style="margin-top:1.5em;margin-bottom:0;">
      <strong>{'How much disk space?'|@translate}</strong>
      <span style="color:orange; font-size:0.8em;" id="community_storage_info">{'no limit'|@translate}</span>
    <input style="color:orange; font-size:0.8em;" type="hidden" name="storage" value="{$storage}">
    </p>
    <div id="community_storage"></div>
   

    {if isset($edit)}
      <input type="hidden" name="edit" value="{$edit}">
    {/if}
    
    <p style="margin-top:1.5em; text-align:center;">
      <input class="submit" type="submit" name="submit_add" value="{if isset($edit)}{'Submit'|@translate}{else}+ {'Add'|@translate}{/if}"/>
          <span style="margin-right: 10px;"></span> <!-- Espace vide -->
      <a href="{$F_ADD_ACTION}">{'Cancel'|@translate}</a>
    </p>
  </fieldset>
</form>
</div>
</div>

<table class="table2" style="margin:15px auto;">
  <tr class="throw">
    <th>{'Who?'|@translate}</th>
    <th>{'Where?'|@translate}</th>
    <th>{'Options'|@translate}</th>
    <th>{'Actions'|@translate}</th>
  </tr>
{if not empty($permissions)}
  {foreach from=$permissions item=permission name=permission_loop}
  <tr class="{if $smarty.foreach.permission_loop.index is odd}row1{else}row2{/if}{if $permission.HIGHLIGHT} rowSelected{/if}">
    <td>{$permission.WHO}</td>
    <td>{$permission.WHERE}</td>
    <td>
      <span title="{$permission.TRUST_TOOLTIP}">{$permission.TRUST}</span>{if $permission.RECURSIVE},
<span title="{$permission.RECURSIVE_TOOLTIP}">{'sub-albums'|@translate}</span>{/if}{if $permission.NB_PHOTOS},
<span title="{$permission.NB_PHOTOS_TOOLTIP}">{'%d photos'|@translate|sprintf:$permission.NB_PHOTOS}</span>{/if}{if $permission.STORAGE},
<span title="{$permission.STORAGE_TOOLTIP}">{$permission.STORAGE}MB</span>{/if}
    {if $permission.CREATE_SUBCATEGORIES}
, {'sub-albums creation'|@translate}
    {/if}
    </td>
    <td class="permissionActions">
      <a href="{$permission.U_EDIT}">
        <img src="{$ROOT_URL}{$themeconf.admin_icon_dir}/edit_s.png" alt="{'edit'|@translate}" title="{'edit'|@translate}" />
      </a>
      <a href="{$permission.U_DELETE}" onclick="return confirm( document.getElementById('btn_delete').title + '\n\n' + '{'Are you sure?'|@translate|@escape:'javascript'}');">
        <img src="{$ROOT_URL}{$themeconf.admin_icon_dir}/delete.png" id="btn_delete" alt="{'delete'|@translate}" title="{'Delete permission'|@translate}" />
      </a>
    </td>
  </tr>
  {/foreach}
{/if}
</table>
