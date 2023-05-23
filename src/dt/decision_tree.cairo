use core::traits::Index;
use core::debug::PrintTrait;
use array::ArrayTrait;
use option::OptionTrait;
use dict::Felt252Dict;
use dict::Felt252DictTrait;
use array::Array;

use traits::TryInto;
use traits::Into;


use decision_tree::onnx_cairo::operators::math::int64;
use decision_tree::onnx_cairo::operators::math::int64::i64;
use decision_tree::onnx_cairo::operators::math::matrix::Matrix;
use decision_tree::onnx_cairo::operators::math::matrix::MatrixTrait;

#[derive(Drop)]
struct DecisionTree {
    X: Matrix,
    y: Matrix
}

trait DTTrait {
    fn new(X: Matrix, y: Matrix) -> DecisionTree;
    fn class_count(self: @DecisionTree) -> Felt252Dict<felt252>;
    fn calculate_gini(self: @DecisionTree) -> u64;
}

impl DTImpl of DTTrait {
    fn new(X: Matrix, y: Matrix) -> DecisionTree {
        create_new(X, y)
    }

    fn class_count(self: @DecisionTree) -> Felt252Dict<felt252> {
        let mut dict: Felt252Dict<felt252> = Felt252DictTrait::new();
        let data_len = self.y.len();

        let mut counter: usize = 0;
        loop {
            if counter == data_len {
                break ();
            }
            let mut data = self.y.get(counter, 0_u32);
            let key: felt252 = data.mag.into();
            let val = dict.get(key);
            dict.insert(key, val + 1);
            counter += 1;
        };
        dict
    }

    fn calculate_gini(self: @DecisionTree) -> u64 {
        let data_len = self.y.len();
        let mut counts = self.class_count();
        let mut impurity = 100_u64;
        let mut counter: felt252 = 0;
        let mut array = unique_array(self);
        let array_len = array.len();

        loop {
            if counter == array_len.into() {
                break ();
            }
            let value = counts.get(array.pop_front().unwrap());
            let val: u64 = value.try_into().unwrap();
            let probability: u64 = val * impurity / data_len.into();

            impurity -= (probability * probability) / impurity;
            counter += 1;
        };
        impurity.print();
        impurity
    }
}

fn create_new(X: Matrix, y: Matrix) -> DecisionTree {
    DecisionTree { X: X, y: y }
}


fn unique_array(value: @DecisionTree) -> Array<felt252> {
    let mut counter: felt252 = 0;
    let data_len = value.y.len();
    let mut a = ArrayTrait::new();
    let mut counts = value.class_count();

    loop {
        if counter == data_len.into() {
            break ();
        }
        let mut val = counts.index(counter);
        if val == 0 { // 'nothing'.print();
        } else {
            a.append(counter)
        }
        counter += 1;
    };
    a
}
