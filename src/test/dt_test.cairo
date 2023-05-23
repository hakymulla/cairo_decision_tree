use core::debug::PrintTrait;
use core::clone::Clone;
use array::ArrayTrait;
use option::OptionTrait;
use dict::Felt252Dict;
use dict::Felt252DictTrait;

use decision_tree::onnx_cairo::operators::math::int64;
use decision_tree::onnx_cairo::operators::math::int64::i64;
use decision_tree::onnx_cairo::operators::math::matrix::MatrixTrait;
use decision_tree::onnx_cairo::operators::math::matrix::Matrix;
use decision_tree::dt::decision_tree::DTTrait;


use decision_tree::math;

#[test]
fn test_math() {
    assert(math::add(2, 3) == 5, 'invalid');
// assert(math::fib(0, 1, 10) == 55, 'invalid');
}

#[test]
#[available_gas(99999999999999999)]
fn dt_test() {
    // Generate some random input data and their corresponding labels
    // For X Matrix
    let mut arr = ArrayTrait::new();

    let val_0 = i64 { mag: 0_u64, sign: false };
    let val_1 = i64 { mag: 1_u64, sign: false };
    let val_2 = i64 { mag: 2_u64, sign: false };
    let val_3 = i64 { mag: 3_u64, sign: false };
    let val_4 = i64 { mag: 4_u64, sign: false };
    let val_5 = i64 { mag: 1_u64, sign: false };
    let val_6 = i64 { mag: 2_u64, sign: false };
    let val_7 = i64 { mag: 3_u64, sign: false };
    let val_8 = i64 { mag: 4_u64, sign: false };
    let val_9 = i64 { mag: 5_u64, sign: false };

    arr.append(val_0);
    arr.append(val_1);
    arr.append(val_2);
    arr.append(val_3);
    arr.append(val_4);
    arr.append(val_5);
    arr.append(val_6);
    arr.append(val_7);
    arr.append(val_8);
    arr.append(val_9);

    // For Y_true values
    let mut arr_y = ArrayTrait::new();

    let val_y_0 = i64 { mag: 0_u64, sign: false };
    let val_y_1 = i64 { mag: 1_u64, sign: false };
    let val_y_2 = i64 { mag: 0_u64, sign: false };
    let val_y_3 = i64 { mag: 1_u64, sign: false };
    let val_y_4 = i64 { mag: 2_u64, sign: false };

    arr_y.append(val_y_0);
    arr_y.append(val_y_1);
    arr_y.append(val_y_2);
    arr_y.append(val_y_3);
    arr_y.append(val_y_4);

    // Data 
    let X = MatrixTrait::new(5_u32, 2_u32, arr);
    let y = MatrixTrait::new(5_u32, 1_u32, arr_y);

    let dt = DTTrait::new(X, y);

    let mut dict: Felt252Dict<felt252> = dt.class_count();
    assert(dict.get(0) == 2, 'wrong');
    assert(dict.get(1) == 2, 'wrong');
    assert(dict.get(2) == 1, 'wrong');
}
#[test]
#[available_gas(99999999999999999)]
fn dt_test_gini_score() {
    // Generate some random input data and their corresponding labels
    // For X Matrix
    let mut arr = ArrayTrait::new();

    let val_0 = i64 { mag: 0_u64, sign: false };
    let val_1 = i64 { mag: 1_u64, sign: false };
    let val_2 = i64 { mag: 2_u64, sign: false };
    let val_3 = i64 { mag: 3_u64, sign: false };
    let val_4 = i64 { mag: 4_u64, sign: false };
    let val_5 = i64 { mag: 1_u64, sign: false };
    let val_6 = i64 { mag: 2_u64, sign: false };
    let val_7 = i64 { mag: 3_u64, sign: false };
    let val_8 = i64 { mag: 4_u64, sign: false };
    let val_9 = i64 { mag: 5_u64, sign: false };

    arr.append(val_0);
    arr.append(val_1);
    arr.append(val_2);
    arr.append(val_3);
    arr.append(val_4);
    arr.append(val_5);
    arr.append(val_6);
    arr.append(val_7);
    arr.append(val_8);
    arr.append(val_9);

    // For Y_true values
    let mut arr_y = ArrayTrait::new();

    let val_y_0 = i64 { mag: 0_u64, sign: false };
    let val_y_1 = i64 { mag: 1_u64, sign: false };
    let val_y_2 = i64 { mag: 2_u64, sign: false };
    let val_y_3 = i64 { mag: 3_u64, sign: false };
    let val_y_4 = i64 { mag: 4_u64, sign: false };

    arr_y.append(val_y_0);
    arr_y.append(val_y_1);
    arr_y.append(val_y_2);
    arr_y.append(val_y_3);
    arr_y.append(val_y_4);

    let mut arr_y_1 = ArrayTrait::new();
    arr_y_1.append(val_y_0);
    arr_y_1.append(val_y_0);
    arr_y_1.append(val_y_1);
    arr_y_1.append(val_y_2);
    arr_y_1.append(val_y_3);

    let mut arr_y_2 = ArrayTrait::new();
    arr_y_2.append(val_y_0);
    arr_y_2.append(val_y_0);
    arr_y_2.append(val_y_1);
    arr_y_2.append(val_y_1);
    arr_y_2.append(val_y_3);

    let mut arr_y_3 = ArrayTrait::new();
    arr_y_3.append(val_y_0);
    arr_y_3.append(val_y_0);
    arr_y_3.append(val_y_1);
    arr_y_3.append(val_y_1);
    arr_y_3.append(val_y_1);

    let mut arr_y_4 = ArrayTrait::new();
    arr_y_4.append(val_y_2);
    arr_y_4.append(val_y_3);
    arr_y_4.append(val_y_3);
    arr_y_4.append(val_y_3);
    arr_y_4.append(val_y_3);

    let mut arr_y_5 = ArrayTrait::new();
    arr_y_5.append(val_y_2);
    arr_y_5.append(val_y_2);
    arr_y_5.append(val_y_2);
    arr_y_5.append(val_y_2);
    arr_y_5.append(val_y_2);

    // Data 
    let X = MatrixTrait::new(5_u32, 2_u32, arr);

    let y = MatrixTrait::new(5_u32, 1_u32, arr_y);
    let y1 = MatrixTrait::new(5_u32, 1_u32, arr_y_1);
    let y2 = MatrixTrait::new(5_u32, 1_u32, arr_y_2);
    let y3 = MatrixTrait::new(5_u32, 1_u32, arr_y_3);
    let y4 = MatrixTrait::new(5_u32, 1_u32, arr_y_4);
    let y5 = MatrixTrait::new(5_u32, 1_u32, arr_y_5);

    let X_cloned1 = X.clone();
    let X_cloned2 = X.clone();
    let X_cloned3 = X.clone();
    let X_cloned4 = X.clone();
    let X_cloned5 = X.clone();

    let dt = DTTrait::new(X, y);
    let dt1 = DTTrait::new(X_cloned1, y1);
    let dt2 = DTTrait::new(X_cloned2, y2);
    let dt3 = DTTrait::new(X_cloned3, y3);
    let dt4 = DTTrait::new(X_cloned4, y4);
    let dt5 = DTTrait::new(X_cloned5, y5);

    let mut gini_score = dt.calculate_gini();
    let mut gini_score1 = dt1.calculate_gini();
    let mut gini_score2 = dt2.calculate_gini();
    let mut gini_score3 = dt3.calculate_gini();
    let mut gini_score4 = dt4.calculate_gini();
    let mut gini_score5 = dt5.calculate_gini();

    assert(gini_score > gini_score1, 'Wrong Implemetation 0');
    assert(gini_score1 > gini_score2, 'Wrong Implemetation 1');
    assert(gini_score2 > gini_score3, 'Wrong Implemetation 2');
    assert(gini_score3 > gini_score4, 'Wrong Implemetation 3');
    assert(gini_score4 > gini_score5, 'Wrong Implemetation 4');
}

