<?php

class graph_customers_insight
{
    public function getWidget()
    {
        global $CACHE_PATH,$ui;
        $u_act = ORM::for_table('tbl_user_recharges')->where('status', 'on')->count();
        if (empty($u_act)) {
            $u_act = '0';
        }
        $ui->assign('u_act', $u_act);

        $u_all = ORM::for_table('tbl_user_recharges')->count();
        if (empty($u_all)) {
            $u_all = '0';
        }
        $ui->assign('u_all', $u_all);


        $c_all = ORM::for_table('tbl_customers')->count();
        if (empty($c_all)) {
            $c_all = '0';
        }
        $ui->assign('c_all', $c_all);

        // Per-plan performance: number of recharges per plan and total revenue per plan (if price available)
        try {
            $plans = ORM::for_table('tbl_plans')->select('id')->select('name_plan')->select('price')->find_array();
            $labels = array();
            $counts = array();
            $revenues = array();
            foreach ($plans as $p) {
                $planId = $p['id'];
                $label = $p['name_plan'] ?: ('Plan ' . $planId);
                $count = ORM::for_table('tbl_user_recharges')->where('plan_id', $planId)->count();
                $price = is_numeric($p['price']) ? (float)$p['price'] : 0.0;
                $revenue = $price * $count;
                $labels[] = $label;
                $counts[] = (int)$count;
                $revenues[] = $revenue;
            }

            // For JS consumption, limit to top 10 plans by count (to keep chart compact)
            $perf = array();
            foreach ($labels as $i => $lab) {
                $perf[] = array('label' => $lab, 'count' => $counts[$i], 'revenue' => $revenues[$i]);
            }
            usort($perf, function ($a, $b) {
                return $b['count'] <=> $a['count'];
            });
            $top = array_slice($perf, 0, 10);
            $plan_labels = array_column($top, 'label');
            $plan_counts = array_column($top, 'count');
            $plan_revenues = array_column($top, 'revenue');

            $ui->assign('plan_perf_labels', json_encode($plan_labels));
            $ui->assign('plan_perf_counts', json_encode($plan_counts));
            $ui->assign('plan_perf_revenues', json_encode($plan_revenues));
        } catch (Exception $e) {
            $ui->assign('plan_perf_labels', json_encode(array()));
            $ui->assign('plan_perf_counts', json_encode(array()));
            $ui->assign('plan_perf_revenues', json_encode(array()));
            error_log('graph_customers_insight: failed to generate plan performance: ' . $e->getMessage());
        }
        return $ui->fetch('widget/graph_customers_insight.tpl');
    }
}