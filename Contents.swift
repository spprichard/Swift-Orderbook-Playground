import Foundation

enum action {
    case buy
    case sell
}
struct Order {
    var action: action
    var price: Double
    var volume: Double
}

enum OrderAttribute{
    case price
    case volume
}
let orders: [Order] = [
    Order(action: .sell, price: 100.10, volume: 100.00),
    Order(action: .sell, price: 100.05, volume: 500.00),
    Order(action: .sell, price: 100.00, volume: 1000.00),
    Order(action: .buy, price: 99.95, volume: 100),
    Order(action: .buy, price: 99.90, volume: 50),
    Order(action: .buy, price: 99.85, volume: 25)
]
print("Number of Orders: \(orders.count)")


extension Array where Element == Order{
    func max(by attribute: OrderAttribute) -> Order? {
        switch attribute {
        case .price:
            let temp = self.sorted { (o1, o2) -> Bool in
                return o1.price < o2.price
            }
            return temp.last
        case .volume:
            let temp = self.sorted { (o1, o2) -> Bool in
                o1.volume < o2.volume
            }
            return temp.last
        }
    }
    
    func min(by attribute: OrderAttribute) -> Order? {
        switch attribute {
        case .price:
            let temp = self.sorted { (o1, o2) -> Bool in
                return o1.price < o2.price
            }
            return temp.first
        case .volume:
            let temp = self.sorted { (o1, o2) -> Bool in
                return o1.volume < o2.volume
            }
            return temp.first
        }
    }
    
    func pullOrders(for action: action) -> [Order] {
        return self.filter { (order) -> Bool in
            return order.action == action
        }
    }
    
    func getMarketPrice(for action: action) -> Double {
        switch action {
        case .buy:
            let sellOrders = self.pullOrders(for: .sell)
            guard let bestOrder = sellOrders.min(by: .price) else {
                print("no buy orders? Num Orders: \(sellOrders.count)")
                return -1.0
            }
            return bestOrder.price
        case .sell:
            let buyOrders = self.pullOrders(for: .buy)
            guard let bestOrder = buyOrders.max(by: .price) else {
                print("no orders? Num Orders: \(buyOrders.count)")
                return -1.0
            }
            return bestOrder.price
        }
    }
    
    func execute(_ order: Order) -> Bool {
        print("Should execute order")
        return false
    }
}

let buys = orders.pullOrders(for: .buy)


let o = orders.max(by: .price)
print("Max Order: \(String(describing: o))")

// Buy, 100, Market -> min sell price
let bestSellPrice = orders.getMarketPrice(for: .sell)
print("Current Best Selling Price: \(bestSellPrice)")


let bestBuyPrice = orders.getMarketPrice(for: .buy)
print("Current Best Buy Price: \(bestBuyPrice)")

let buyOrder = Order(action: .buy, price: orders.getMarketPrice(for: .buy), volume: 100)
print(buyOrder)



