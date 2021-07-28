//
//  ViewController.m
//  objC
//
//  Created by Hiago Chagas on 23/07/21.
//

#import "ViewController.h"
#import "ScratchView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Gabi - teste com jpg e constraints definindo tamanho da imagem e posição
    ScratchView *scratch1 = [ScratchView.new initWithUIImage: [UIImage imageNamed:@"background.jpg"]];
    self.navigationItem.title = @"Scratch";
    self.navigationController.navigationBar.prefersLargeTitles = YES;

    scratch1.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview: scratch1];

    [scratch1.widthAnchor constraintEqualToConstant:150].active = YES;
    [scratch1.heightAnchor constraintEqualToConstant:250].active = YES;
    [scratch1.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant: 50].active = YES;
    [scratch1.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant: 150].active = YES;

    //Gabi - teste com png e constraints definindo só a posição da imageView e deixando o tamanho ser definido pela UIImage passada no init
    ScratchView *scratch2 = [ScratchView.new initWithUIImage: [UIImage imageNamed:@"tartaruga.png"]];
    self.navigationItem.title = @"Scratch";
    self.navigationController.navigationBar.prefersLargeTitles = YES;

    scratch2.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview: scratch2];

    [scratch2.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [scratch2.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant: -150].active = YES;
}


@end
