//
//  ScratchView.m
//  CGScratch
//
//  Created by Olivier Yiptong on 11-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScratchView.h"
#import "ScratchableView.h"


@implementation ScratchView


/// Gabi - Inicia ScratchView com a imagem que ficará encoberta na "raspadinha"
/// @param image imagem que ficará no background da view scratchable
- (id)initWithUIImage:(UIImage *)image {

    //Gabi - Em vez de ser passado por parametro, o frame é criado com o size da imagem
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);

    //Gabi - o init agora é feito com esse frame criado a partir do tamanho da imagem
    self = [super initWithFrame:frame];

    if (self) {

        //Gabi - A imageview é criada sem image
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectZero];
        background.image = image; //Gabi - image setado aqui
        background.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:background];

        /* Gabi - É necessário por clipsToBounds para os casos onde a imagem ultrapassa a área da imageView.
         * Nesse caso, sem clipsToBounds a scratchableView (que tem o mesmo tamanho da imageView)
         * fica em cima só da imageView, não escondendo a parte da imagem que está "vazando" dos
         * limites (bounds) da imageView.
         */
        [self setClipsToBounds: YES];

        background.translatesAutoresizingMaskIntoConstraints = false;

        /* Gabi - A imageView agora está "colada" na ScratchView com constraints, pra que ela sempre se
         * redimensione junto com qualquer constraint que for configurada para a própria
         * ScratchView (na controller, por exemplo).
         */
        [NSLayoutConstraint activateConstraints: @[
            [background.topAnchor constraintEqualToAnchor: self.topAnchor],
            [background.bottomAnchor constraintEqualToAnchor: self.bottomAnchor],
            [background.leadingAnchor constraintEqualToAnchor: self.leadingAnchor],
            [background.trailingAnchor constraintEqualToAnchor: self.trailingAnchor]
        ]];
    }
    return self;
}


/* Gabi - A função drawRect faz parte do ciclo de vida da UIView, e só é chamada na renderização, último estágio
 * da criação da UIView, onde as constraints já foram aplicadas, e o UIKit está prestes a desenhar de fato
 * a view na tela na posicao e tamanho certo. Somente aqui que ciramos a ScratchableView com o mesmo tamanho
 * da ScratchView após a aplicação das constraints, e a adicionamos como subview.
 *
 * Dessa forma ela vai ter o tamanho do frame já certo com o que for redimensionado via constraint pelo user la na constroller.
 * Se vocês optarem por sempre usar só frame, quem pegar esse framework pra usar vai ter a mesma limitação.
 *
 * Mais info sobre a drawRect tem na doc oficial. Esse link aqui tbm explica direitinho:
 * https://www.vadimbulavin.com/view-auto-layout-life-cycle/
 * Escolhi usar ele porque ele já recebe certinho por parametro o rect, e só é chamado uma vez nesse caso, diferente da layoutSubviews que ta sendo chamado duas vezes por algum motivo.
 */
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    ScratchableView *scratchableView = [[ScratchableView alloc] initWithFrame: rect];
    [self addSubview:scratchableView];
}

@end
