{combine_script id='jquery.ui.slider' require='jquery.ui' load='footer' path='themes/default/js/ui/minified/jquery.ui.slider.min.js'}
{combine_css path="themes/default/js/ui/theme/jquery.ui.slider.css"}
{combine_script id='batchManagerGlobal' load='async' require='jquery' path='plugins/community/admin_permission.js'}

{combine_script id='common' load='footer' path='admin/themes/default/js/common.js'}
{combine_css id='common' path="plugins/community/admin_permission.css"}

{footer_script}{literal}


{/literal}{/footer_script}

{if not isset($edit)}
<div style="display:flex;">
  <div style="display:flex; align-items: center;">
<a id="displayForm" href="#" >
  <div class=" permission-header-button" >
    <label class="head-button-2 icon-plus-circled">
     <span>{'Add a permission'|@translate}</span>
    </label>
  </div>
</a>
  </div>
</div>
{/if}

<form method="post" name="add_permission" action="{$F_ADD_ACTION}" class="properties" {if not isset($edit)}style="display:none"{/if}>
  <fieldset>
    <legend>{if isset($edit)}{'Edit a permission'|@translate}{else}{'Add a permission'|@translate}{/if}</legend>

    <p>
      <strong>{'Who?'|@translate}</strong>
      <br>
      <select name="who">
{html_options options=$who_options selected=$who_options_selected}
      </select>

      <select name="who_user" {if not isset($user_options_selected)}style="display:none"{/if}>
{html_options options=$user_options selected=$user_options_selected}
      </select>

      <select name="who_group" {if not isset($group_options_selected)}style="display:none"{/if}>
{html_options options=$group_options selected=$group_options_selected}
      </select>
    </p>

    <p>
      <strong>{'Where?'|@translate}</strong> {if $community_conf.user_albums}<em id="userAlbumInfo">{'(in addition to user album)'|@translate}</em>{/if}
      <br>
      <select class="categoryDropDown" name="category">
{if $community_conf.user_albums}
        <option value="-1"{if $user_album_selected} selected="selected"{/if} id="userAlbumOption">{'User album only'|@translate}</option>
{/if}
        <option value="0"{if $whole_gallery_selected} selected="selected"{/if}>{'The whole gallery'|@translate}</option>
        <option disabled="disabled">------------</option>
        {html_options options=$category_options selected=$category_options_selected}
      </select>
      <br>
      <label><input type="checkbox" name="recursive" {if $recursive}checked="checked"{/if}> {'Apply to sub-albums'|@translate}</label>
      <br>
      <label><input type="checkbox" name="create_subcategories" {if $create_subcategories}checked="checked"{/if}> {'ability to create sub-albums'|@translate}</label>
    </p>

    <p>
      <strong>{'Which level of trust?'|@translate}</strong>
      <br><label><input type="radio" name="moderated" value="true" {if $moderated}checked="checked"{/if}> <em>{'low trust'|@translate}</em> : {'uploaded photos must be validated by an administrator'|@translate}</label>
      <br><label><input type="radio" name="moderated" value="false" {if not $moderated}checked="checked"{/if}> <em>{'high trust'|@translate}</em> : {'uploaded photos are directly displayed in the gallery'|@translate}</label>
    </p>

    <p style="margin-bottom:0">
      <strong>{'How many photos?'|@translate}</strong>
    </p>
    <div id="community_nb_photos"></div>
    <span id="community_nb_photos_info">{'no limit'|@translate}</span>
    <input type="hidden" name="nb_photos" value="{$nb_photos}">

    <p style="margin-top:1.5em;margin-bottom:0;">
      <strong>{'How much disk space?'|@translate}</strong>
    </p>
    <div id="community_storage"></div>
    <span id="community_storage_info">{'no limit'|@translate}</span>
    <input type="hidden" name="storage" value="{$storage}">

    {if isset($edit)}
      <input type="hidden" name="edit" value="{$edit}">
    {/if}

    <p style="margin-top:1.5em;">
      <input class="submit" type="submit" name="submit_add" value="{if isset($edit)}{'Submit'|@translate}{else}{'Add'|@translate}{/if}"/>
      <a href="{$F_ADD_ACTION}">{'Cancel'|@translate}</a>
    </p>
  </fieldset>
</form>
<div id="permission-table">
  <table id="permission-table-content">
    <thead class="table-head">
    <tr>
      <th class="permission-header-id">#</th>
      <th class="permission-header-who">{'Who?'|@translate}</th>
      <th class="permission-header-where">{'Where?'|@translate}</th>
      <th class="permission-header-trust">{'Trust'|@translate}</th>
      <th class="permission-header-options">{'Options'|@translate}</th>
      <th class="permission-header-actions">{'Actions'|@translate}</th>
    </tr>
    </thead>
    {if not empty($permissions)}
      {foreach from=$permissions item=permission name=permission_loop}
        <tr class="permission-col">
          <td>{$permission.ID}</td>
          <td class="permission-container-who">{$permission.WHO}</td>
          <td>{$permission.WHERE}</td>
          <td>
            <span title="{$permission.TRUST_TOOLTIP}">{$permission.TRUST}</span>
          </td>
          <td class="permission-col-options">
            {if $permission.RECURSIVE}
              <span title="{$permission.RECURSIVE_TOOLTIP}">{'sub-albums'|@translate}</span>
            {/if}
            {if $permission.NB_PHOTOS}
              {if $permission.RECURSIVE},{/if}
              <span title="{$permission.NB_PHOTOS_TOOLTIP}">{'%d photos'|@translate|sprintf:$permission.NB_PHOTOS}</span>
            {/if}
            {if $permission.STORAGE}
              {if $permission.RECURSIVE or $permission.NB_PHOTOS},{/if}
              <span title="{$permission.STORAGE_TOOLTIP}">{$permission.STORAGE}MB</span>
            {/if}
            {if $permission.CREATE_SUBCATEGORIES}
              {if $permission.RECURSIVE or $permission.NB_PHOTOS or $permission.STORAGE},{/if}
              {'sub-albums creation'|@translate}
            {/if}
          </td>
          <td class="permissionActions">
            <a href="{$permission.U_EDIT}">
              <span class="icon-pencil" style="font-size: 18px;"></span>
            </a>
            <a href="{$permission.U_DELETE}" onclick="return confirm( document.getElementById('btn_delete').title + '\n\n' + '{'Are you sure?'|@translate|@escape:'javascript'}');">
              <span class="icon-trash" style="font-size: 18px;"></span>
            </a>
          </td>

        </tr>
      {/foreach}
    {/if}
  </table>
</div>
