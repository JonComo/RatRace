//
//  RRMarketViewController.m
//  RatRace
//
//  Created by Jon Como on 9/1/13.
//  Copyright (c) 2013 Jon Como. All rights reserved.
//

#import "RRMarketViewController.h"

#import "RRRandomNewsViewController.h"

#import "RRGame.h"
#import "RRItem.h"

#import "SMStatsView.h"
#import "RRTravelViewController.h"
#import "RRBankViewController.h"
#import "RRDiamondCell.h"
#import "RRButtonSound.h"
#import "RRGraphics.h"

#import "MBProgressHUD.h"

#import "RREvent.h"

#import "RRAudioEngine.h"

#define MAX_CONCURRENT_EVENTS 3

@interface RRMarketViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    SMStatsView *statsView;
    RRTravelViewController *travelController;
    
    __weak IBOutlet RRButtonSound *travelButton;
    __weak IBOutlet RRButtonSound *bankButton;
    
    int eventIndex;
}

@end

@implementation RRMarketViewController
{
    __weak IBOutlet UICollectionView *collectionViewItems;
    RRAudioPlayer *strings;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[RRGame sharedGame] newGame];
    
    [RRGraphics buttonStyle:travelButton];
    [RRGraphics buttonStyle:bankButton];
    
    collectionViewItems.allowsMultipleSelection = NO;
    [collectionViewItems registerNib:[UINib nibWithNibName:@"diamondCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"diamondCell"];
    
    [self addStatsView];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:RRDiamondCountChanged object:nil queue:nil usingBlock:^(NSNotification *note) {
        //[collectionViewItems reloadData];
    }];
    
    //music
    strings = [[RRAudioEngine sharedEngine] playSoundNamed:@"strings" extension:@"wav" loop:YES];
    strings.volume = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self deselectAllItems];
    [collectionViewItems reloadData];
    
    [strings fadeIn:2];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addRandomEvent];
    [self runEvents];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [strings fadeOut:1];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRDiamondCountChanged object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addRandomEvent
{
    [self randomWithChance:15 run:^{
        
        float interest = [RRGame sharedGame].bank.interest;
        float newInterest = MAX(0, interest + (float)(arc4random()%20)/100);
        UIImage *image = [UIImage imageNamed:@"suisse"];
        
        if (interest != newInterest)
        {
            
            RREvent *interestEvent = [RREvent eventWithInitialBlock:^{
                
                
                float previousInterest = [RRGame sharedGame].bank.interest;
                [RRGame sharedGame].bank.interest = MAX(0, interest + (float)(arc4random()%20)/100);
                
                NSString *change;
                
                if (previousInterest < [RRGame sharedGame].bank.interest)
                {
                    change = @"raised";
                }else{
                    change = @"lowered";
                }
                
                [self showHUDWithTitle:[NSString stringWithFormat:@"Bank interest %@!", change] detail:[NSString stringWithFormat:@"Swiss banks have %@ their interest rate to %.1f%%!", change, [RRGame sharedGame].bank.interest * 100] autoDismiss:NO image:image];
                
                
            } numberOfDays:4 endingBlock:^{
                
                NSString *change;
                
                if (interest < [RRGame sharedGame].bank.interest)
                {
                    change = @"lowered";
                }else{
                    change = @"raised";
                }
                
                [RRGame sharedGame].bank.interest = interest;
                
                [self showHUDWithTitle:[NSString stringWithFormat:@"Bank interest %@!", change] detail:[NSString stringWithFormat:@"Swiss banks have %@ their interest rate to %.1f%%!", change, [RRGame sharedGame].bank.interest * 100] autoDismiss:NO image:image];
            }];
            
            interestEvent.type = RREventTypeInterest;
            
            [self addEvent:interestEvent];
        }
    }];
    
    [self randomWithChance:15 run:^{
        
        if ([[RRGame sharedGame].player inventoryCount] == 0) return;
        
        NSMutableArray *itemsWithCounts = [NSMutableArray array];
        
        for (RRItem *item in [RRGame sharedGame].availableItems)
        {
            if (item.count > 0) [itemsWithCounts addObject:item];
        }
        
        RRItem *randomItem = itemsWithCounts[arc4random()%itemsWithCounts.count];
        
        int numberToTake = MAX(1, arc4random()%randomItem.count);
        
        RREvent *confiscate = [RREvent eventWithInitialBlock:^{
            
            randomItem.count -= numberToTake;
            
            NSLog(@"SEIZED: %i", numberToTake);
            
            [collectionViewItems reloadData];
            
            [self showHUDWithTitle:@"Diamonds seized!" detail:[NSString stringWithFormat:@"Interpol has seized %i of your %@(s). Investigation number: %i revealed possible link to theivery.", numberToTake, randomItem.name, arc4random()%1000] autoDismiss:NO image:[UIImage imageNamed:@"badge"]];
            
        } numberOfDays:1 endingBlock:nil];
        
        confiscate.type = RREventTypeSeize;
        
        [self addEvent:confiscate];
    }];
    
    [self randomWithChance:15 run:^{
        
        int giftAmount = 1 + arc4random()%7;
        RRItem *giftedItem = [RRGame sharedGame].availableItems[arc4random()%[RRGame sharedGame].availableItems.count];
        
        RREvent *gift = [RREvent eventWithInitialBlock:^{
            
            giftedItem.count += giftAmount;
            
            [self showHUDWithTitle:@"Received diamonds!" detail:[NSString stringWithFormat:@"You've received %i %@(s) from a mysterious source.", giftAmount, giftedItem.name] autoDismiss:NO image:[UIImage imageNamed:@"diamond-in-hand"]];
            
            [collectionViewItems reloadData];
        } numberOfDays:2+arc4random()%4 endingBlock:^{
            [self randomWithChance:20 run:^{
                //take back those diamonds!
                
                if (giftedItem.count >= giftAmount){
                    giftedItem.count -= giftAmount;
                    
                    [self showHUDWithTitle:@"Tainted gift!" detail:[NSString stringWithFormat:@"Your gift of %i %@(s) turned out to be stolen. They were seized.",giftAmount, giftedItem.name] autoDismiss:NO image:[UIImage imageNamed:@"badge"]];
                    
                    [collectionViewItems reloadData];
                }
            }];
            
        }];
        
        [self addEvent:gift];
    }];
    
    [self randomWithChance:15 run:^{
        RREvent *inventoryPlus = [RREvent eventWithInitialBlock:^{
            int additionalSlots = 5 + arc4random()%25;
            
            [RRGame sharedGame].player.inventoryCapacity += additionalSlots;
            
            [self showHUDWithTitle:@"Bigger breifcase!" detail:[NSString stringWithFormat:@"You found a bigger breifcase. How much bigger? %i slots bigger!", additionalSlots] autoDismiss:NO image:[UIImage imageNamed:@"cut_diamonds"]];
        } numberOfDays:1 endingBlock:nil];
        
        [self addEvent:inventoryPlus];
    }];
    
    eventIndex = [RRGame sharedGame].events.count-1;
}

-(void)addEvent:(RREvent *)event
{
    if ([RRGame sharedGame].events.count > MAX_CONCURRENT_EVENTS) return;
    
    BOOL shouldAdd = YES;
    
    for (RREvent *currentEvent in [RRGame sharedGame].events)
    {
        if (currentEvent.type == event.type)
        {
            shouldAdd = NO;
        }
    }
    
    if (shouldAdd){
        [[RRGame sharedGame].events addObject:event];
    }
}

-(void)randomWithChance:(int)chance run:(void(^)(void))block
{
    if (arc4random()%100 < chance)
    {
        if (block) block();
    }
}

-(void)runEvents
{
    if (eventIndex < 0) return;

    RREvent *event = [RRGame sharedGame].events[eventIndex];
    [event progressDay];
    
    eventIndex --;
}

-(void)showHUDWithTitle:(NSString *)title detail:(NSString *)detail autoDismiss:(BOOL)autoDismiss image:(UIImage *)image
{
    NSLog(@"SHOWING HUD: %@", title);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = title;
    hud.detailsLabelText = detail;
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.color = [UIColor whiteColor];
    hud.labelFont = [UIFont fontWithName:@"Avenir" size:18];
    hud.detailsLabelFont = [UIFont fontWithName:@"Avenir" size:14];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 140)];
    imageView.image = image;
    hud.customView = imageView;
    
    if (autoDismiss)
    {
        [hud hide:YES afterDelay:3];
    }else{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD)];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [hud addGestureRecognizer:tap];
        });
    }
}

-(void)hideHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [self runEvents];
}

-(void)addStatsView
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"stats"
                                                      owner:self
                                                    options:nil];
    
    statsView = (SMStatsView *)nibViews[0];
    
    NSLog(@"%f", statsView.frame.size.height);
    
    
    [statsView setup];
    
    [self.view addSubview:statsView];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RRDiamondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"diamondCell" forIndexPath:indexPath];
    
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    cell.item = item;
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [RRGame sharedGame].availableItems.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[RRAudioEngine sharedEngine] playSoundNamed:@"click" extension:@"aiff" loop:NO];
    
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    if (item.selected)
    {
        item.selected = NO;
        [collectionViewItems reloadData];
    }else{
        [self deselectAllItems];
        item.selected = YES;
        
        [collectionViewItems reloadData];
        [collectionViewItems scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RRItem *item = [RRGame sharedGame].availableItems[indexPath.row];
    
    return item.selected ? CGSizeMake(320, 144) : CGSizeMake(320, 44);
}

-(void)deselectAllItems
{
    for (RRItem *item in [RRGame sharedGame].availableItems)
    {
        item.selected = NO;
    }
}

-(RRItem *)selectedItem
{
    RRItem *selected;
    
    for (RRItem *item in [RRGame sharedGame].availableItems)
    {
        if (item.selected)
        {
            selected = item;
        }
    }
    
    return selected;
}

- (IBAction)bank:(id)sender
{
    NSString *bankLocation = [RRGame sharedGame].availableLocations[0];
    
    if (![[RRGame sharedGame].location isEqualToString:bankLocation]) {
        // Show
        [self showHUDWithTitle:@"Cannot access bank." detail:[NSString stringWithFormat:@"%@ is not where you want to manage your finances. Go back to %@.", [RRGame sharedGame].location, bankLocation] autoDismiss:NO image:[UIImage imageNamed:@"debeers"]];
        return;
    }
    
    RRBankViewController *bankView = [[RRBankViewController alloc] initWithNibName:@"RRBankViewController" bundle:[NSBundle mainBundle]];
    
    JLBPartialModal *modal = [JLBPartialModal sharedInstance];
    modal.delegate = bankView;
    [modal presentViewController:bankView dismissal:^{
        
    }];

}

- (IBAction)travel:(id)sender {
    [[RRGame sharedGame] advanceDay];
    
    RRTravelViewController *travelVC = [self.storyboard instantiateViewControllerWithIdentifier:@"travelVC"];
    
    [self presentViewController:travelVC animated:YES completion:nil];
}


@end