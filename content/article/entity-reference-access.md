+++
title = "CTools access plugin : Entity reference has value"
date = "2015-01-23"
draft = false
image = "ctools.jpg"
categories = ["Drupal"]
tags = ["Code example"]
author = "Tom Helmer Hansen"
+++

CTools and Panels is a powerful toolbox for Drupal developers. One of the great features is defining visibility rules for content inserted with panels based on CTools access plugins. My experience is that using the builtin field value check against an empty value does not work.

We made a visibility rule to display / not display content when a configurable entity reference field has been filled or not.

### The visibility settings form
Our rule is called "Node: Entity reference defined" and the settings form will show a dropdown list with all entity reference field for nodes.

{{% img src="/images/rule-settings.png" %}}

### The code
First add the ctools plugin directory hook to your .module file. If you already has one then modify it to look in the access folder as well.

    /**
    * Implements hook_ctools_plugin_directory().
    */
    function MYMODULE_ctools_plugin_directory($module, $plugin) {
      if ($module == 'ctools' && $plugin == 'access') {
        return "plugins/$plugin";
      }
    }

Next create the plugins/access folder and the plugin file eg. "er_defined.inc". The plugin file must have a $plugin array used by ctools to get the plugin configuration. The plugin has "node" as a required context and callbacks for summary, access check and settings.

    /**
     * Plugins are described by creating a $plugin array which will
     * be used by the system that includes the file.
     */
    $plugin = array(
      'title' => t('Node: Entity reference defined'),
      'description' => t('Only displays this pane if the entity reference is defined.'),
      'callback' => 'MYMODULE_er_defined_ctools_access_check',
      'default' => array('field_widget' => 1),
      'summary' => 'MYMODULE_er_defined_summary',
      'required context' => new ctools_context_required(t('Node'), 'node'),
      'settings form' => 'MYMODULE_er_defined_ctools_settings',
    );

## Summary callback
The summary callback function is used as the label when rigth-clicking the pane settings. If this function isn't defined you can't see the applied visibility rules.

    function MYMODULE_er_defined_summary($conf, $context) {
      return 'Entity reference "' . $conf['field_name'] . '" is set';
    }

## Settings form callback
The settings form is used to configure the visibility rule. It builds an option array with field names of all entity reference fields for nodes.

    /**
     * Settings form for the 'er_defined' access plugin.
     */
    function MYMODULE_er_defined_ctools_settings($form, &$form_state, $conf) {
      $instances = array();
      $field_instances = field_info_instances('node');
      foreach ($field_instances as $bundle_name => $bundle) {
        foreach ($bundle as $field_name => $value) {
          $field_info = field_info_field($field_name);
          if ($field_info['type'] == 'entityreference') {
            $instances[$field_name] = $field_name;
          }
        }
      }

      $form['settings']['field_name'] = array(
        '#type' => 'select',
        '#title' => t('Entity reference field'),
        '#options' => $instances,
        '#default_value' => $conf['field_name'],
      );
      return $form;
    }

## The access callback
The last function does the actual work of checking if the entity reference has a value. We use [field_get_items](https://api.drupal.org/api/drupal/modules%21field%21field.module/function/field_get_items/7) to make sure language settings are handled properly.

    /**
     * Custom callback defined by 'callback' in the $plugin array.
     *
     * Check for access.
     */
    function MYMODULE_er_defined_ctools_access_check($conf, $context) {

      // If for some unknown reason that $context isn't set, return false.
      if (empty($context) || empty($context->data)) {
        return FALSE;
      }

      // Get field values.
      $reference = field_get_items('node', $context->data, $conf['field_name']);
      return $reference !== FALSE;

    }



