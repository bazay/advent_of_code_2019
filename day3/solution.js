'use strict'

// Part 1
// ======

const part1 = input => {
    const intersections = getIntersectingPoints(input);
    return getClosestDistance(intersections);
};

// Part 2
// ======

const part2 = input => {
    const intersections = getIntersectingPoints(input);
    return getShortestStepCount(intersections);
};

module.exports = {part1, part2};

function getIntersectingPoints(input) {
    const wires = input.split('\n');
    let instructions1 = wires[0].split(',');
    let instructions2 = wires[1].split(',');

    const wirePoints1 = parseWirePoints(instructions1);
    const wirePoints2 = parseWirePoints(instructions2);

    return getIntersections(wirePoints1, wirePoints2);
}

function parseWirePoints(instructions) {
    let wirePoints = [];
   let x = 0;
    let y = 0;
    let counter = 0;
    const instructionLength = instructions.length;
    for (let i = 0; i < instructionLength; i++) {
        const instruction = instructions[i];
        const steps = parseInt(instruction.substr(1), 10);
        switch (instruction.charAt(0)) {
            case 'D':
                for (let j = 0; j < steps; j++) {
                    wirePoints.push({x: x, y: --y, steps: ++counter});
                }
                break;
            case 'U':
                for (let j = 0; j < steps; j++) {
                    wirePoints.push({x: x, y: ++y, steps: ++counter});
                }
                break;
            case 'L':
                for (let j = 0; j < steps; j++) {
                    wirePoints.push({x: --x, y: y, steps: ++counter});
                }
                break;
            case 'R':
                for (let j = 0; j < steps; j++) {
                    wirePoints.push({x: ++x, y: y, steps: ++counter});
                }
                break;
        }
    }
    return wirePoints;
}

function getIntersections(wirePoints1, wirePoints2) {
    let intersections = [];
    wirePoints1.forEach(function (point) {
        wirePoints2.forEach(function (point2) {
            if (point.x == point2.x && point.y == point2.y) {
                point.steps += point2.steps;
                intersections.push(point);
            }
        })
    });
    return intersections;
}

function getClosestDistance(intersections) {
    let distance = getDistance(intersections[0]);
    intersections.forEach(point => {
        distance = Math.min(distance, getDistance(point))
    });
    return distance;
}

function getDistance(intersection) {
    let distanceX = intersection.x < 0 ? intersection.x * -1 : intersection.x;
    let distanceY = intersection.y < 0 ? intersection.y * -1 : intersection.y;

    return distanceX + distanceY;
}

function getShortestStepCount(intersections) {
    let steps = intersections[0].steps;
    intersections.forEach(point => {
        steps = Math.min(steps, point.steps)
    });
    return steps;
} 
