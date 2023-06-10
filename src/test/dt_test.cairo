use core::traits::Into;
use core::traits::TryInto;
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
use decision_tree::dt::decision_tree::get_unique_values;
use decision_tree::dt::decision_tree::calculate_gini;
use decision_tree::dt::decision_tree::class_count;


#[test]
#[available_gas(99999999999999999)]
fn dt_class_count_test() {
    // Generate some random input data and their corresponding labels
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
    let y = MatrixTrait::new(5_u32, 1_u32, arr_y);

    let mut dict: Felt252Dict<felt252> = class_count(@y);
    assert(dict.get(0) == 2, 'wrong');
    assert(dict.get(1) == 2, 'wrong');
    assert(dict.get(2) == 1, 'wrong');
}

#[test]
#[available_gas(99999999999999999)]
fn dt_test_gini_score() {
    // Generate some random input data and their corresponding labels
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

    let y = MatrixTrait::new(5_u32, 1_u32, arr_y);
    let y1 = MatrixTrait::new(5_u32, 1_u32, arr_y_1);
    let y2 = MatrixTrait::new(5_u32, 1_u32, arr_y_2);
    let y3 = MatrixTrait::new(5_u32, 1_u32, arr_y_3);
    let y4 = MatrixTrait::new(5_u32, 1_u32, arr_y_4);
    let y5 = MatrixTrait::new(5_u32, 1_u32, arr_y_5);

    let mut gini_score = calculate_gini(@y);
    let mut gini_score1 = calculate_gini(@y1);
    let mut gini_score2 = calculate_gini(@y2);
    let mut gini_score3 = calculate_gini(@y3);
    let mut gini_score4 = calculate_gini(@y4);
    let mut gini_score5 = calculate_gini(@y5);

    assert(gini_score > gini_score1, 'Wrong Implemetation 0');
    assert(gini_score1 > gini_score2, 'Wrong Implemetation 1');
    assert(gini_score2 > gini_score3, 'Wrong Implemetation 2');
    assert(gini_score3 > gini_score4, 'Wrong Implemetation 3');
    assert(gini_score4 > gini_score5, 'Wrong Implemetation 4');
}

#[test]
#[available_gas(99999999999999999)]
fn test_get_column_int64() {
    // Generate some random input data and their corresponding labels
    // For X Matrix
    let mut arr = ArrayTrait::new();

    let val_0 = i64 { mag: 0_u64, sign: false };
    let val_1 = i64 { mag: 1_u64, sign: false };
    let val_2 = i64 { mag: 0_u64, sign: false };
    let val_3 = i64 { mag: 1_u64, sign: false };
    let val_4 = i64 { mag: 0_u64, sign: false };
    let val_5 = i64 { mag: 2_u64, sign: false };
    let val_6 = i64 { mag: 1_u64, sign: false };
    let val_7 = i64 { mag: 1_u64, sign: false };
    let val_8 = i64 { mag: 2_u64, sign: false };
    let val_9 = i64 { mag: 2_u64, sign: false };

    let val_10 = i64 { mag: 0_u64, sign: false };
    let val_11 = i64 { mag: 0_u64, sign: false };
    let val_12 = i64 { mag: 1_u64, sign: false };
    let val_13 = i64 { mag: 0_u64, sign: false };
    let val_14 = i64 { mag: 2_u64, sign: false };
    let val_15 = i64 { mag: 1_u64, sign: false };
    let val_16 = i64 { mag: 1_u64, sign: false };
    let val_17 = i64 { mag: 3_u64, sign: false };
    let val_18 = i64 { mag: 3_u64, sign: false };
    let val_19 = i64 { mag: 3_u64, sign: false };

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
    arr.append(val_10);
    arr.append(val_11);
    arr.append(val_12);
    arr.append(val_13);
    arr.append(val_14);
    arr.append(val_15);
    arr.append(val_16);
    arr.append(val_17);
    arr.append(val_18);
    arr.append(val_19);

    // Data 
    let X = MatrixTrait::new(10_u32, 2_u32, arr);
    let first_column = X.get_column(0);
    assert(first_column.len() == 10, 'Wrong lenght of rows');
    assert(*first_column.at(0).mag == 0_u64, 'Wrong Value in Index');
    assert(*first_column.at(1).mag == 0_u64, 'Wrong Value in Index');
    assert(*first_column.at(3).mag == 1_u64, 'Wrong Value in Index');
    assert(*first_column.at(7).mag == 2_u64, 'Wrong Value in Index');
    assert(*first_column.at(9).mag == 3_u64, 'Wrong Value in Index');
}

#[test]
#[available_gas(99999999999999999)]
fn test_get_unique_values() {
    let mut arr = ArrayTrait::new();

    let val_0 = i64 { mag: 0_u64, sign: false };
    let val_1 = i64 { mag: 1_u64, sign: false };
    let val_2 = i64 { mag: 0_u64, sign: false };
    let val_3 = i64 { mag: 1_u64, sign: false };
    let val_4 = i64 { mag: 0_u64, sign: false };
    let val_5 = i64 { mag: 2_u64, sign: false };
    let val_6 = i64 { mag: 1_u64, sign: false };
    let val_7 = i64 { mag: 1_u64, sign: false };
    let val_8 = i64 { mag: 2_u64, sign: false };
    let val_9 = i64 { mag: 2_u64, sign: false };

    let val_10 = i64 { mag: 0_u64, sign: false };
    let val_11 = i64 { mag: 0_u64, sign: false };
    let val_12 = i64 { mag: 1_u64, sign: false };
    let val_13 = i64 { mag: 0_u64, sign: false };
    let val_14 = i64 { mag: 2_u64, sign: false };
    let val_15 = i64 { mag: 1_u64, sign: false };
    let val_16 = i64 { mag: 1_u64, sign: false };
    let val_17 = i64 { mag: 3_u64, sign: false };
    let val_18 = i64 { mag: 3_u64, sign: false };
    let val_19 = i64 { mag: 4_u64, sign: false };

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
    arr.append(val_10);
    arr.append(val_11);
    arr.append(val_12);
    arr.append(val_13);
    arr.append(val_14);
    arr.append(val_15);
    arr.append(val_16);
    arr.append(val_17);
    arr.append(val_18);
    arr.append(val_19);

    // Data 
    let X = MatrixTrait::new(10_u32, 2_u32, arr);
    let first_column = X.get_column(0);
    let second_column = X.get_column(1);

    let unique_values_first_column = get_unique_values(@first_column);
    let unique_values_second_column = get_unique_values(@second_column);

    assert(unique_values_first_column.len() == 4, 'Incorrect unique value');
    assert(unique_values_second_column.len() == 5, 'Incorrect unique value');
}

#[test]
#[available_gas(99999999999999999)]
fn dt_test_find_split() {
    // Generate some random input data and their corresponding labels
    // For X Matrix
    let mut arr = ArrayTrait::new();

    let val_0 = i64 { mag: 3_u64, sign: false };
    let val_2 = i64 { mag: 1_u64, sign: false };
    let val_4 = i64 { mag: 7_u64, sign: false };
    let val_6 = i64 { mag: 1_u64, sign: false };
    let val_8 = i64 { mag: 2_u64, sign: false };
    let val_10 = i64 { mag: 3_u64, sign: false };
    let val_12 = i64 { mag: 4_u64, sign: false };
    let val_14 = i64 { mag: 5_u64, sign: false };
    let val_16 = i64 { mag: 2_u64, sign: false };
    let val_18 = i64 { mag: 1_u64, sign: false };

    let val_y_0 = i64 { mag: 0_u64, sign: false };
    let val_y_1 = i64 { mag: 1_u64, sign: false };
    let val_y_2 = i64 { mag: 2_u64, sign: false };
    let val_y_3 = i64 { mag: 3_u64, sign: false };
    let val_y_4 = i64 { mag: 4_u64, sign: false };
    let val_y_5 = i64 { mag: 1_u64, sign: false };
    let val_y_6 = i64 { mag: 1_u64, sign: false };
    let val_y_7 = i64 { mag: 2_u64, sign: false };
    let val_y_8 = i64 { mag: 1_u64, sign: false };
    let val_y_9 = i64 { mag: 1_u64, sign: false };

    let val_1 = i64 { mag: 2_u64, sign: false };
    let val_3 = i64 { mag: 0_u64, sign: false };
    let val_5 = i64 { mag: 4_u64, sign: false };
    let val_7 = i64 { mag: 1_u64, sign: false };
    let val_9 = i64 { mag: 3_u64, sign: false };
    let val_11 = i64 { mag: 0_u64, sign: false };
    let val_13 = i64 { mag: 0_u64, sign: false };
    let val_15 = i64 { mag: 1_u64, sign: false };
    let val_17 = i64 { mag: 2_u64, sign: false };
    let val_19 = i64 { mag: 0_u64, sign: false };

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
    arr.append(val_10);
    arr.append(val_11);
    arr.append(val_12);
    arr.append(val_13);
    arr.append(val_14);
    arr.append(val_15);
    arr.append(val_16);
    arr.append(val_17);
    arr.append(val_18);
    arr.append(val_19);

    // For Y_true values
    let mut arr_y = ArrayTrait::new();

    arr_y.append(val_y_0);
    arr_y.append(val_y_1);
    arr_y.append(val_y_2);
    arr_y.append(val_y_3);
    arr_y.append(val_y_4);
    arr_y.append(val_y_5);
    arr_y.append(val_y_6);
    arr_y.append(val_y_7);
    arr_y.append(val_y_8);
    arr_y.append(val_y_9);

    // Data 
    let X = MatrixTrait::new(10_u32, 2_u32, arr);
    let y = MatrixTrait::new(10_u32, 1_u32, arr_y);

    let dt = DTTrait::new(X, y);
    let X_len: u64 = dt.X.cols.into();

    let mut i = 0_u64;

    loop {
        if i == X_len {
            break ();
        }
        // 'column'.print();
        let split = dt.find_split(i);
        // split.score.print();
        // split.bestsplit.print();
        i += 1;
    }
}
// X1      y
// 0      0
// 0      0
// 0      1
// 1      0
// 2      0
// 0      0
// 1      1
// 2      0
// 1      1
// 3      2

// 


