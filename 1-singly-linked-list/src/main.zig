const std = @import("std");

var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

const allocator = arena.allocator();

pub fn LinkedList(comptime T: type) type {
    return struct {
        const This = @This();

        const Node = struct {
            value: T,
            next: ?*Node,
        };

        head: ?*Node,
        tail: ?*Node,

        pub fn init() This {
            return LinkedList(T) {
                .head = null,
                .tail = null,
            };
        }

        pub fn add(this: *This, value: T) !void {
            var newNode = try allocator.create(Node);

            newNode.* = .{ .value = value, .next = null };

            if (this.tail) |tail| {
                tail.next = newNode;
                this.tail = newNode;
            } else if (this.head) |head| {
                head.next = newNode;
                this.tail = newNode;
            } else {
                this.head = newNode;
            }
        }
    };
}

pub fn main() anyerror!void {
    var l1 = LinkedList(i32).init();

    try l1.add(1);
    try l1.add(2);
    try l1.add(4);
    try l1.add(3);

    var h = l1.head;

    while (h) |head| : (h = head.next) {
        std.log.info("> {}", .{ head.value });
    }
}

test "basic test" {
    var l1 = LinkedList(i32).init();

    try l1.add(1);
    try l1.add(2);
    try l1.add(4);
    try l1.add(3);

    var h = l1.head;

    const items = [_]i32 { 1, 2, 4, 3 };

    for (items) |item| {
        try std.testing.expectEqual(h.?.*.value, item);
        h = h.?.*.next;
    }

    try std.testing.expectEqual(h, null);
}
