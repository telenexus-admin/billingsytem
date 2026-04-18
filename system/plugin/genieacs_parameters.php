<?php
// File: system/plugin/genieacs_parameters.php

// Check admin user type before registering menu
$admin = Admin::_info();
if (in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
    register_menu("GenieACS Parameters", true, "genieacs_parameters", 'AFTER_genieacs_manager', 'ion ion-settings');
}

function genieacs_parameters()
{
    global $ui, $routes;
    _admin();
    $ui->assign('_title', 'GenieACS Parameters');
    $ui->assign('_system_menu', 'genieacs_parameters');
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);

    // Check user type for access
    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    $action = $routes['2'] ?? '';
    $id = $routes['3'] ?? '';

    switch ($action) {
        case 'add':
            genieacs_add_parameter();
            break;
        case 'edit':
            genieacs_edit_parameter();
            break;
        case 'delete':
            if (!empty($id)) {
                genieacs_delete_parameter($id);
            } else {
                r2(U . 'plugin/genieacs_parameters', 'e', 'Invalid parameter ID!');
            }
            break;
        case 'save':
            genieacs_save_parameter();
            break;
        case 'update':
            genieacs_update_parameter();
            break;
        case 'reorder':
            genieacs_reorder_parameters();
            break;
        default:
            genieacs_parameter_list();
            break;
    }
}


function genieacs_parameter_list()
{
    global $ui;

    // Get all parameters
    $parameters = ORM::for_table('tbl_acs_parameters')
        ->order_by_asc('display_order')
        ->order_by_asc('param_category')
        ->find_many();

    // Group by category
    $grouped_params = [];
    foreach ($parameters as $param) {
        $category = $param->param_category ?: 'general';
        if (!isset($grouped_params[$category])) {
            $grouped_params[$category] = [];
        }
        $grouped_params[$category][] = $param;
    }

    $ui->assign('grouped_params', $grouped_params);
    $ui->display('genieacs_parameters.tpl');
}

function genieacs_save_parameter()
{
    if ($_POST) {
        $param_key = trim($_POST['param_key']);
        $param_label = trim($_POST['param_label']);
        $param_path = trim($_POST['param_path']);
        $param_type = $_POST['param_type'];
        $param_category = trim($_POST['param_category']);
        $is_required = isset($_POST['is_required']) ? 1 : 0;
        $display_order = intval($_POST['display_order']);

        // Validation - param_path boleh kosong untuk kategori config
        if (empty($param_key) || empty($param_label)) {
            r2(U . 'plugin/genieacs_parameters', 'e', 'Key and Label are required!');
            return;
        }
        
        // param_path wajib diisi kecuali untuk kategori config
        if (empty($param_path) && $param_category !== 'config') {
            r2(U . 'plugin/genieacs_parameters', 'e', 'Path is required for non-config parameters!');
            return;
        }

        // Check if key already exists
        $existing = ORM::for_table('tbl_acs_parameters')
            ->where('param_key', $param_key)
            ->find_one();

        if ($existing) {
            r2(U . 'plugin/genieacs_parameters', 'e', 'Parameter key already exists!');
            return;
        }

        // Save new parameter
        $param = ORM::for_table('tbl_acs_parameters')->create();
        $param->param_key = $param_key;
        $param->param_label = $param_label;
        $param->param_path = $param_path;
        $param->param_type = $param_type;
        $param->param_category = $param_category;
        $param->is_required = $is_required;
        $param->display_order = $display_order;
        $param->save();

        r2(U . 'plugin/genieacs_parameters', 's', 'Parameter added successfully!');
    }
}

function genieacs_update_parameter()
{
    if ($_POST) {
        $id = intval($_POST['id']);
        $param_label = trim($_POST['param_label']);
        $param_path = trim($_POST['param_path']);
        $param_type = $_POST['param_type'];
        $param_category = trim($_POST['param_category']);
        $is_required = isset($_POST['is_required']) ? 1 : 0;
        $display_order = intval($_POST['display_order']);

        // Validation - param_path boleh kosong untuk kategori config
        if (empty($param_label)) {
            r2(U . 'plugin/genieacs_parameters', 'e', 'Label is required!');
            return;
        }
        
        // param_path wajib diisi kecuali untuk kategori config
        if (empty($param_path) && $param_category !== 'config') {
            r2(U . 'plugin/genieacs_parameters', 'e', 'Path is required for non-config parameters!');
            return;
        }

        $param = ORM::for_table('tbl_acs_parameters')->find_one($id);

        if (!$param) {
            r2(U . 'plugin/genieacs_parameters', 'e', 'Parameter not found!');
            return;
        }

        $param->param_label = $param_label;
        $param->param_path = $param_path;
        $param->param_type = $param_type;
        $param->param_category = $param_category;
        $param->is_required = $is_required;
        $param->display_order = $display_order;
        $param->save();

        r2(U . 'plugin/genieacs_parameters', 's', 'Parameter updated successfully!');
    }
}

function genieacs_delete_parameter($id)
{
    $id = intval($id);

    if ($id <= 0) {
        r2(U . 'plugin/genieacs_parameters', 'e', 'Invalid parameter ID!');
        return;
    }

    try {
        $param = ORM::for_table('tbl_acs_parameters')->find_one($id);

        if ($param) {
            // Force delete regardless of required status for testing
            $param->delete();
            r2(U . 'plugin/genieacs_parameters', 's', 'Parameter deleted successfully!');
        } else {
            r2(U . 'plugin/genieacs_parameters', 'e', 'Parameter not found with ID: ' . $id);
        }
    } catch (Exception $e) {
        r2(U . 'plugin/genieacs_parameters', 'e', 'Database error: ' . $e->getMessage());
    }
}

// Helper function to get parameters
function get_acs_parameters($type = null, $category = null)
{
    $query = ORM::for_table('tbl_acs_parameters');

    if ($type) {
        $query->where_raw('(param_type = ? OR param_type = ?)', [$type, 'both']);
    }

    if ($category) {
        $query->where('param_category', $category);
    }

    return $query->order_by_asc('display_order')->find_many();
}

// Helper function to get parameter value from device data
function get_parameter_value($device_data, $param_path)
{
    // Handle different path types
    if (strpos($param_path, 'VirtualParameters.') === 0) {
        // Virtual parameter
        $vp_name = str_replace('VirtualParameters.', '', $param_path);
        return $device_data['VirtualParameters'][$vp_name]['_value'] ?? 'N/A';
    } elseif ($param_path === '_id') {
        // Device ID
        return $device_data['_id'] ?? 'N/A';
    } else {
        // Standard TR-069 path
        $path_parts = explode('.', $param_path);
        $value = $device_data;

        foreach ($path_parts as $part) {
            if (isset($value[$part])) {
                $value = $value[$part];
            } else {
                return 'N/A';
            }
        }

        return isset($value['_value']) ? $value['_value'] : $value;
    }
}
