<?php

class info_payment_gateway
{

    public function getWidget($data = null)
    {
        global $ui;
        // Payments processed today: successful (status=2), failed (status=3), pending/unpaid (status=1)
        $today = date('Y-m-d');
        try {
            // successful: paid_date is today and status = 2
            $successful = ORM::for_table('tbl_payment_gateway')
                ->where('status', 2)
                ->where_raw("DATE(paid_date) = ?", array($today))
                ->count();

            // failed: paid_date is today and status = 3
            $failed = ORM::for_table('tbl_payment_gateway')
                ->where('status', 3)
                ->where_raw("DATE(paid_date) = ?", array($today))
                ->count();

            // pending/unpaid: created_date is today and status = 1
            $pending = ORM::for_table('tbl_payment_gateway')
                ->where('status', 1)
                ->where_raw("DATE(created_date) = ?", array($today))
                ->count();

            $payments_today = array(
                'successful' => (int)$successful,
                'failed' => (int)$failed,
                'pending' => (int)$pending,
            );
        } catch (Exception $e) {
            $payments_today = array('successful' => 0, 'failed' => 0, 'pending' => 0);
            error_log('info_payment_gateway: failed to fetch today\'s payment counts: ' . $e->getMessage());
        }

        $ui->assign('payments_today', $payments_today);

        return $ui->fetch('widget/info_payment_gateway.tpl');
    }
}